extends Node
class_name NightUIManager

# ui
@onready var night_start_layer: CanvasLayer = $Screen
@onready var night_label: Label = $Screen/Label
@onready var ui_timer_layer: CanvasLayer = $Timer
@onready var ui_timer_label: Label = $Timer/Panel/Label

var timer_text := '00:00'


func _process(delta: float) -> void:
	ui_timer_label.text = timer_text


func show_night(num: int) -> void:
	night_label.text = 'Night ' + str(num) 
	night_start_layer.visible = true
	ui_timer_layer.visible = false


func show_planning_ui() -> void:
	night_start_layer.visible = false
	ui_timer_layer.visible = true


func show_invader_warning_ui() -> void:
	night_label.text = 'The invaders are now approaching...'
	night_start_layer.visible = true
	ui_timer_layer.visible = false


func show_invading_ui() -> void:
	night_start_layer.visible = false
	ui_timer_layer.visible = true


func show_victory_ui() -> void:
	night_label.text = 'Kevin survived the night!'
	night_start_layer.visible = true
	ui_timer_layer.visible = false
