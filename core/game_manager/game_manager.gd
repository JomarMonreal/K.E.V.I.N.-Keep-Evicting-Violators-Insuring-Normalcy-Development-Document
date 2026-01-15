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
var current_night : int = 1

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


func change_world_scene(new_scene: String, action : OldSceneAction = OldSceneAction.DELETE):
	print("changing")
	if is_instance_valid(current_world_scene):
		match action:
			OldSceneAction.DELETE:
				current_world_scene.queue_free() # delete scene in memory
			OldSceneAction.HIDE:
				current_world_scene.visible = false # hide scene but keep in memory
			OldSceneAction.REMOVE:
				world_scene.remove_child(current_world_scene) # hide scene and dont keep running
	
	var new = load(new_scene).instantiate()
	world_scene.add_child(new)
	current_world_scene = new
	
	if new.has_signal("night_victory"):
		new.night_victory.connect(_advance_night)


func change_ui_scene(new_scene: String, action : OldSceneAction = OldSceneAction.DELETE):
	if is_instance_valid(current_ui_scene):
		match action:
			OldSceneAction.DELETE:
				current_ui_scene.queue_free() # delete scene in memory
			OldSceneAction.HIDE:
				current_ui_scene.visible = false # hide scene but keep in memory
			OldSceneAction.REMOVE:
				gui.remove_child(current_ui_scene) # hide scene and dont keep running
	
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_ui_scene = new


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
	current_night += 1
	if current_night >= MAX_NIGHTS:
		end_game(GameCondition.VICTORY)
	
	Global.game_manager.change_world_scene("res://scenes/main/night.tscn") # next night


func _on_player_killed() -> void:
	end_game(GameCondition.KILLED)


func _on_player_insane() -> void:
	end_game(GameCondition.INSANE)
