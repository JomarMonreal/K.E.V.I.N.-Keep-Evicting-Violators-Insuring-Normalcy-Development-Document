extends Control

@export var delay : float = 3.5

func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	Global.game_manager.change_world_scene('')
	Global.game_manager.change_ui_scene(Constants.SCENE_PATHS.main_menu)
