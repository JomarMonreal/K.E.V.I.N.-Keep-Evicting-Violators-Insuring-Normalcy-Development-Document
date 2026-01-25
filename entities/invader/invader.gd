extends RigidBody2D
class_name Invader

@onready var states: InvaderStateManager = $StateManager
@onready var sprite: Sprite2D = $Sprite2D
@export var path_graph: PathGraph
@export var speed: float = 100
@export var maxFear: int = 100

var current_fear: int = 0
var target_node: PathNode
var current_node: PathNode
var scare_direction: Vector2 = Vector2.ZERO
var trap_redirect_distance: float = 300.0

signal leaving_scared
signal leaving_with_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_node = path_graph.get_nodes_by_role(PathNode.Role.ENTRANCE).pick_random()
	global_position = current_node.global_position
	target_node = current_node.neighbors.pick_random()
	states.initial_state = InvaderBaseState.State.Idle
	states.init(self)

func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
func _input(event: InputEvent) -> void:
	states.input(event)
