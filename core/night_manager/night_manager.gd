extends Node
class_name NightManager

@export var planning_background: Texture2D
@export var invading_background: Texture2D

@onready var path_graph: PathGraph = $PathGraph
@onready var loading_timer: Timer = $LoadingTimer
@onready var planning_timer: Timer = $PlanningTimer
@onready var plan_to_invade_timer: Timer = $PlanToInvadeTimer
@onready var invading_timer: Timer = $InvadingTimer
@onready var night_start_layer: CanvasLayer = $Camera2D/NightStart/Screen
@onready var night_label: Label = $Camera2D/NightStart/Screen/Label
@onready var ui_timer_layer: CanvasLayer = $Camera2D/NightStart/Timer
@onready var ui_label_label: Label = $Camera2D/NightStart/Timer/Panel/Label

signal has_started_planning
signal has_ended_planning
signal has_started_invading
signal has_ended_invading

# Called when the node enters "res://assets/main_assets/Map/Map_Planning.png"the scene tree for the first time.
func _ready() -> void:
	path_graph.background_sprite.texture = planning_background
	night_label.text = 'Night ' + str(Global.current_night) 
	night_start_layer.visible = true
	ui_timer_layer.visible = false
	loading_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var t_left := 0.0

	if ui_timer_layer.visible:
		if not planning_timer.is_stopped():
			t_left = planning_timer.time_left
		elif not invading_timer.is_stopped():
			t_left = invading_timer.time_left

	var total := int(ceil(max(t_left, 0.0)))
	var mins := total / 60
	var secs := total % 60
	ui_label_label.text = "%02d:%02d" % [mins, secs]


func _on_loading_timer_timeout() -> void:
	has_started_planning.emit()
	night_start_layer.visible = false
	ui_timer_layer.visible = true
	loading_timer.stop()
	planning_timer.start()
	pass # Replace with function body.


func _on_planning_timer_timeout() -> void:
	has_ended_planning.emit()
	planning_timer.stop()
	night_label.text = 'The invaders are now approaching...'
	night_start_layer.visible = true
	ui_timer_layer.visible = false
	plan_to_invade_timer.start()
	pass # Replace with function body.


func _on_plan_to_invade_timer_timeout() -> void:
	has_started_invading.emit()
	path_graph.background_sprite.texture = invading_background
	night_start_layer.visible = false
	ui_timer_layer.visible = true
	plan_to_invade_timer.stop()
	invading_timer.start()
	pass # Replace with function body.


func _on_invading_timer_timeout() -> void:
	has_ended_invading.emit()
	night_label.text = 'Kevin survived the night!'
	night_start_layer.visible = true
	ui_timer_layer.visible = false
	invading_timer.stop()
	pass # Replace with function body.
