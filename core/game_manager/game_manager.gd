class_name GameManager
extends Node

enum GameCondition {
	VICTORY,
	KILLED,
	INSANE,
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


func change_world_scene(new_scene: String, delete: bool = true, keep_running: bool = false):
	print("changing")
	if current_world_scene:
		if delete:
			current_world_scene.queue_free() #delete scene in memory
		elif keep_running:
			current_world_scene.visible = false #hide scene but keep in memory
		else:
			world_scene.remove_child(current_world_scene) #sumunod lang ako sa tutorial idk what this is
	
	var new = load(new_scene).instantiate()
	world_scene.add_child(new)
	current_world_scene = new


func change_ui_scene(new_scene: String, delete: bool = true, keep_running: bool = false):
	if current_ui_scene:
		if delete:
			current_ui_scene.queue_free() #delete scene in memory
		elif keep_running:
			current_ui_scene.visible = false #hide scene but keep in memory
		else:
			gui.remove_child(current_ui_scene) #sumunod lang ako sa tutorial idk what this is
	
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


func advance_night() -> void:
	Global.current_night += 1
	if Global.current_night > MAX_NIGHTS:
		end_game(GameCondition.VICTORY)


func _on_player_killed() -> void:
	end_game(GameCondition.KILLED)


func _on_player_insane() -> void:
	end_game(GameCondition.INSANE)
