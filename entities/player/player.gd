extends CharacterBody2D
class_name Player

@onready var states: PlayerStateManager = $StateManager

var motion_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	states.init(self)

func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
func _input(event: InputEvent) -> void:
	states.input(event)
