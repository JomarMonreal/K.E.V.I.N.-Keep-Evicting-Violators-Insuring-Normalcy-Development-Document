extends Control

@export var delay : float = 3.5

func _ready() -> void:
	AudioManager.create_2d_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.VICTORY_ENDING)
	await get_tree().create_timer(delay).timeout
	Global.game_manager.change_world_scene('')
	Global.game_manager.change_ui_scene(Constants.SCENE_PATHS.main_menu)
