class_name GameManager
extends Node

enum GameCondition {
	VICTORY,
	KILLED,
	INSANE,
}

enum OldSceneAction {
	DELETE,
	HIDE,
	REMOVE,
}

const MAX_NIGHTS: int = 7

@export var world_scene : Node2D
@export var gui : Control
var current_world_scene
var current_ui_scene



func _ready() -> void:
	Global.game_manager = self

	current_ui_scene = $GUI/MainMenu
	
	EventListener.player_killed.connect(_on_player_killed)
	EventListener.insanity_reached.connect(_on_player_insane)
	EventListener.night_victory.connect(_advance_night)

func change_world_scene(new_scene: String, is_world_next_scene: bool = true, action : OldSceneAction = OldSceneAction.DELETE):
	print("changing")
	if is_instance_valid(current_world_scene):
		match action:
			OldSceneAction.DELETE:
				current_world_scene.queue_free() # delete scene in memory
				print("VALID")
				print(current_world_scene)
			OldSceneAction.HIDE:
				current_world_scene.visible = false # hide scene but keep in memory
			OldSceneAction.REMOVE:
				world_scene.remove_child(current_world_scene) # hide scene and dont keep running
	if new_scene != '':
		var new = load(new_scene).instantiate()
		world_scene.add_child(new)
		if is_world_next_scene:
			current_world_scene = new
		else:
			current_ui_scene = new
		


func change_ui_scene(new_scene: String, is_ui_next_scene: bool = true, action : OldSceneAction = OldSceneAction.DELETE):
	if is_instance_valid(current_ui_scene):
		match action:
			OldSceneAction.DELETE:
				current_ui_scene.queue_free() # delete scene in memory
			OldSceneAction.HIDE:
				current_ui_scene.visible = false # hide scene but keep in memory
			OldSceneAction.REMOVE:
				gui.remove_child(current_ui_scene) # hide scene and dont keep running

	if new_scene != '':
		print("CHANGED SCENE")
		var new = load(new_scene).instantiate()
		gui.add_child(new)
		if is_ui_next_scene:
			current_ui_scene = new
		else:
			current_world_scene = new
		
	


func start_game() -> void:
	pass


func end_game(condition: GameCondition) -> void:
	if condition == null:
		return

	if condition == GameCondition.VICTORY:
		pass
	elif condition == GameCondition.KILLED:
		pass
	elif condition == GameCondition.INSANE:
		pass


func _advance_night() -> void:
	print("next night!")
	Global.current_night += 1
	if Global.current_night >= MAX_NIGHTS:
		end_game(GameCondition.VICTORY)
	
	Global.game_manager.change_world_scene("res://scenes/main/night.tscn") # next night
	Global.game_manager.change_ui_scene('')
	


func _on_player_killed() -> void:
	end_game(GameCondition.KILLED)


func _on_player_insane() -> void:
	end_game(GameCondition.INSANE)
