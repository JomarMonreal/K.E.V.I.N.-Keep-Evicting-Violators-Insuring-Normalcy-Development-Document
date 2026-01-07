extends Node
class_name NightManager

@export var planning_background: Texture2D
@export var invading_background: Texture2D

@onready var path_graph: PathGraph = $PathGraph
@onready var loading_timer: Timer = $LoadingTimer
@onready var planning_timer: Timer = $PlanningTimer
@onready var plan_to_invade_timer: Timer = $PlanToInvadeTimer
@onready var invading_timer: Timer = $InvadingTimer
@onready var night_start_layer: CanvasLayer = $Camera2D/NightStart/CanvasLayer
@onready var night_panel_label: Label = $Camera2D/NightStart/CanvasLayer/Label

signal has_started_planning
signal has_ended_planning
signal has_started_invading
signal has_ended_invading

# Called when the node enters "res://assets/main_assets/Map/Map_Planning.png"the scene tree for the first time.
func _ready() -> void:
	path_graph.background_sprite.texture = planning_background
	night_panel_label.text = 'Night ' + str(Global.current_night) 
	loading_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_loading_timer_timeout() -> void:
	has_started_planning.emit()
	night_start_layer.visible = false
	loading_timer.stop()
	planning_timer.start()
	pass # Replace with function body.


func _on_planning_timer_timeout() -> void:
	has_ended_planning.emit()
	planning_timer.stop()
	night_panel_label.text = 'The invaders are now approaching...'
	night_start_layer.visible = true
	plan_to_invade_timer.start()
	pass # Replace with function body.


func _on_plan_to_invade_timer_timeout() -> void:
	has_started_invading.emit()
	path_graph.background_sprite.texture = invading_background
	night_start_layer.visible = false
	plan_to_invade_timer.stop()
	invading_timer.start()
	pass # Replace with function body.
