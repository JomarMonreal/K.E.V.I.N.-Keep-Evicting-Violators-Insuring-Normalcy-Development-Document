extends Control

@export_file(".tscn") var main_scene : String = ""

@export var delay : float = 0.2

@onready var play_button : Button = $Control/Play


func _on_play_pressed() -> void:
	AudioManager.create_2d_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON_CLICK)
	await get_tree().create_timer(delay).timeout
	Global.game_manager.change_ui_scene('')
	Global.game_manager.change_world_scene(main_scene) #insert scene to night
	

func _on_settings_pressed() -> void:
	print("settings!")
	AudioManager.create_2d_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON_CLICK)


func _on_quit_pressed() -> void:
	AudioManager.create_2d_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON_CLICK)
	await get_tree().create_timer(delay).timeout
	get_tree().quit()
