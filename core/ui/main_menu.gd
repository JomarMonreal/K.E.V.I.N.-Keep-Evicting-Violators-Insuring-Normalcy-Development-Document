extends Control

@export_file(".tscn") var main_scene : String = ""

@onready var play_button : Button = $PanelContainer/MarginContainer/VBoxContainer/ButtonVbox/Play
@onready var settings_button : Button = $PanelContainer/MarginContainer/VBoxContainer/ButtonVbox/Settings
@onready var quit_button : Button = $PanelContainer/MarginContainer/VBoxContainer/ButtonVbox/Quit


func _on_play_pressed() -> void:
	print("play!")
	Global.game_manager.change_ui_scene(main_scene, true, true) #insert scene to night 1
	


func _on_settings_pressed() -> void:
	print("settings!")


func _on_quit_pressed() -> void:
	get_tree().quit()
