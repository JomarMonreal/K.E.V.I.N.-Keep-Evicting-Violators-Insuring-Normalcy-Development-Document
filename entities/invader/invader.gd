extends RigidBody2D
class_name Invader

@onready var states: InvaderStateManager = $StateManager
@onready var sprite: Sprite2D = $Sprite2D
@onready var walk_sound_timer: Timer = $WalkSoundTimer

@export var path_graph: PathGraph
@export var speed: float = 100
@export var maxFear: int = 100

const MIN_WALK_TIME = 2.0
const MAX_WALK_TIME = 10.0

var current_fear: int = 0
var target_node: PathNode
var current_node: PathNode
var scare_direction: Vector2 = Vector2.ZERO
var trap_redirect_distance: float = 300.0

@warning_ignore("unused_signal")
signal leaving_scared
@warning_ignore("unused_signal")
signal leaving_with_item


func _ready() -> void:
	current_node = path_graph.get_nodes_by_role(PathNode.Role.ENTRANCE).pick_random()
	global_position = current_node.global_position
	target_node = current_node.neighbors.pick_random()
	
	states.initial_state = InvaderBaseState.State.Idle
	states.init(self)
	
	randomize_walk_time()


func _process(delta: float) -> void:
	states.process(delta)


func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _input(event: InputEvent) -> void:
	states.input(event)


func _on_walk_sound_timer_timeout() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.INVADER_WALKING)
	randomize_walk_time()


func randomize_walk_time():
	var chance : float = randf_range(MIN_WALK_TIME, MAX_WALK_TIME)
	walk_sound_timer.wait_time = chance
