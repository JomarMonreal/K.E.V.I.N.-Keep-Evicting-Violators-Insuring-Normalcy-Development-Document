extends Node
class_name NightManager

# background
@export var planning_background: Texture2D
@export var invading_background: Texture2D
@export var sentimental_item_scene: PackedScene

# pathing
@onready var path_graph: PathGraph = $PathGraph
@onready var player: Player = $Player
@onready var invader: Invader = $InvaderHandler/Invader

# timers
@onready var loading_timer: Timer = $LoadingTimer
@onready var planning_timer: Timer = $PlanningTimer
@onready var plan_to_invade_timer: Timer = $PlanToInvadeTimer
@onready var invading_timer: Timer = $InvadingTimer
@onready var results_timer: Timer = $ResultsTimer

# ui
@onready var ui_manager: NightUIManager = $Camera2D/NightUIManager
@onready var post_processing : CanvasLayer = $Camera2D/PostProcessing

# phases
signal has_started_planning
signal has_ended_planning
signal has_started_invading
signal has_ended_invading


# Called when the node enters "res://assets/main_assets/Map/Map_Planning.png"the scene tree for the first time.
func _ready() -> void:
	path_graph.background_sprite.texture = planning_background
	invader.visible = false
	post_processing.visible = false
	ui_manager.show_night(Global.current_night)
	var item_node = path_graph.get_nodes_by_role(PathNode.Role.ITEM).pick_random()
	var sentimental_item = sentimental_item_scene.instantiate()
	sentimental_item.global_position = item_node.global_position
	get_tree().root.add_child(sentimental_item)
	loading_timer.start()


func _process(_delta: float) -> void:
	var t_left := 0.0

	if not planning_timer.is_stopped():
		t_left = planning_timer.time_left
	elif not invading_timer.is_stopped():
		t_left = invading_timer.time_left

	var total := int(ceil(max(t_left, 0.0)))
	@warning_ignore("integer_division") var mins := total / 60
	var secs := total % 60
	ui_manager.timer_text = "%02d:%02d" % [mins, secs]


func _on_loading_timer_timeout() -> void:
	has_started_planning.emit()
	
	path_graph.background_sprite.texture = planning_background
	ui_manager.show_planning_ui()
	
	loading_timer.stop()
	planning_timer.start()


func _on_planning_timer_timeout() -> void:
	has_ended_planning.emit()
	
	ui_manager.show_invader_warning_ui()
	invader.visible = true
	
	planning_timer.stop()
	plan_to_invade_timer.start()


func _on_plan_to_invade_timer_timeout() -> void:
	has_started_invading.emit()
	
	path_graph.background_sprite.texture = invading_background
	ui_manager.show_invading_ui()
	post_processing.visible = true
	invader.states.change_state(InvaderBaseState.State.Moving)
	
	plan_to_invade_timer.stop()
	invading_timer.start()


func _on_invading_timer_timeout() -> void:
	has_ended_invading.emit()
	
	post_processing.visible = false
	ui_manager.show_victory_ui()
	
	results_timer.start()
	invading_timer.stop()


func _on_results_timer_timeout() -> void:
	EventListener.night_victory.emit()
	print("EMITTED NIGHT VICTORY")
	
	results_timer.stop()


func _on_invader_leaving_scared() -> void:
	post_processing.visible = false
	ui_manager.show_victory_ui()
	results_timer.start()
	invading_timer.stop()


func _on_invader_leaving_with_item() -> void:
	post_processing.visible = false
	print("EMITTED LEAVING ITEM")
	ui_manager.show_stolen_ui()
	player.sanity += 30
	if player.sanity >= player.MAX_SANITY:
		EventListener.insanity_reached.emit()
	results_timer.start()
	invading_timer.stop()
