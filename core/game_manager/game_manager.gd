class_name GameManager
extends Node

enum GameCondition {
	VICTORY,
	KILLED,
	INSANE,
}

const MAX_NIGHTS : int = 7
@onready var current_night : int = 0

@export var world_scene : Node2D
var current_scene: Node2D
#var current_ui_scene: Control


func _ready() -> void:
	Global.game_manager = self
	
	EventListener.player_killed.connect(_on_player_killed)
	EventListener.insanity_reached.connect(_on_player_insane)


func change_scene(new_scene: String, delete: bool = true, keep_running: bool = false):
	if current_scene:
		if delete:
			current_scene.queue_free() #delete scene in memory
		elif keep_running:
			current_scene.visible = false #hide scene but keep in memory
		else:
			remove_child(current_scene) #sumunod lang ako sa tutorial idk what this is
	
	var new = load(new_scene).instantiate()
	add_child(new)
	current_scene = new


func start_game():
	pass


func end_game(condition: GameCondition):
	if not condition:
		return
	
	if condition == GameCondition.VICTORY:
		pass
	elif condition == GameCondition.KILLED:
		pass
	elif condition == GameCondition.INSANE:
		pass


func advance_night():
	current_night += 1
	
	if current_night > MAX_NIGHTS:
		end_game(GameCondition.VICTORY)


func _on_player_killed():
	end_game(GameCondition.KILLED)


func _on_player_insane():
	end_game(GameCondition.INSANE)
