class_name GameManager
extends Node

enum GameCondition {
	VICTORY,
	KILLED,
	INSANE,
}

const MAX_NIGHTS: int = 7

# key -> PackedScene
@export var scenes: Dictionary[StringName, PackedScene] = {}

var current_scene: Node2D


func _ready() -> void:
	Global.game_manager = self

	EventListener.player_killed.connect(_on_player_killed)
	EventListener.insanity_reached.connect(_on_player_insane)


func change_scene(scene_key: StringName, delete: bool = true, keep_running: bool = false) -> void:
	if current_scene:
		if delete:
			current_scene.queue_free()
		elif keep_running:
			current_scene.visible = false
		else:
			remove_child(current_scene)

	var packed: PackedScene = scenes.get(scene_key)
	if packed == null:
		push_error("GameManager.change_scene: Unknown scene_key '%s'." % String(scene_key))
		return

	var next_scene := packed.instantiate() as Node2D
	if next_scene == null:
		push_error("GameManager.change_scene: Scene '%s' is not a Node2D." % String(scene_key))
		return

	add_child(next_scene)
	current_scene = next_scene


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
