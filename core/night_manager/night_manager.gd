extends Node
class_name NightManager

@export var planning_background: Texture2D
@export var invading_background: Texture2D

@onready var path_graph: PathGraph = $PathGraph
var night_number = 1

# timers
@onready var loading_timer: Timer = $LoadingTimer
@onready var planning_timer: Timer = $PlanningTimer
@onready var plan_to_invade_timer: Timer = $PlanToInvadeTimer
@onready var invading_timer: Timer = $InvadingTimer

# ui
@onready var ui_manager: NightUIManager = $Camera2D/NightUIManager

signal has_started_planning
signal has_ended_planning
signal has_started_invading
signal has_ended_invading

# Called when the node enters "res://assets/main_assets/Map/Map_Planning.png"the scene tree for the first time.
func _ready() -> void:
	path_graph.background_sprite.texture = planning_background
	ui_manager.show_night(night_number)
	loading_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var t_left := 0.0

	if not planning_timer.is_stopped():
		t_left = planning_timer.time_left
	elif not invading_timer.is_stopped():
		t_left = invading_timer.time_left

	var total := int(ceil(max(t_left, 0.0)))
	var mins := total / 60
	var secs := total % 60
	ui_manager.timer_text = "%02d:%02d" % [mins, secs]


func _on_loading_timer_timeout() -> void:
	has_started_planning.emit()
	ui_manager.show_planning_ui()
	loading_timer.stop()
	planning_timer.start()


func _on_planning_timer_timeout() -> void:
	has_ended_planning.emit()
	ui_manager.show_invader_warning_ui()
	planning_timer.stop()
	plan_to_invade_timer.start()
	pass # Replace with function body.


func _on_plan_to_invade_timer_timeout() -> void:
	has_started_invading.emit()
	path_graph.background_sprite.texture = invading_background
	ui_manager.show_invading_ui()
	plan_to_invade_timer.stop()
	invading_timer.start()
	Global.is_night_planning = false

func _on_invading_timer_timeout() -> void:
	has_ended_invading.emit()
	ui_manager.show_victory_ui()
	invading_timer.stop()
	EventListener.night_victory.emit()
