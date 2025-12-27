extends StaticBody2D
class_name Invader

@onready var states: InvaderStateManager = $StateManager
@export var path_graph: PathGraph
var target_node: PathNode
var current_node: PathNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_node = path_graph.entrance_nodes.pick_random()
	global_position = current_node.position
	target_node = current_node.neighbors.pick_random()
	states.init(self)

func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
func _input(event: InputEvent) -> void:
	states.input(event)
