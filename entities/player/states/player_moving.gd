extends PlayerBaseState
## Player Moving State

@export var idle_state : PlayerBaseState
#@export var interact_state : PlayerBaseState
@export var hiding_state : PlayerBaseState


func enter():
	super()


func physics_process(_delta: float) -> BaseState:
	if not parent.is_planning:
		return hiding_state
	
	#var direction := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	#Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	
	if parent.velocity == Vector2.ZERO:
		return idle_state
	
	if parent.velocity.x != 0:
		parent.animations.flip_h = parent.velocity.x < 0
	
	return null
