extends StaticBody2D
class_name Invader

@onready var states: InvaderStateManager = $StateManager
@export var path_graph: PathGraph
@export var speed: float = 100
@export var maxFear: int = 100

var currentFear: int = 0
var target_node: PathNode
var current_node: PathNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_node = path_graph.get_nodes_by_role(PathNode.Role.ENTRANCE).pick_random()
	global_position = current_node.global_position
	target_node = current_node.neighbors.pick_random()
	states.initial_state = InvaderBaseState.State.Moving
	states.init(self)

func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
func _input(event: InputEvent) -> void:
	states.input(event)
