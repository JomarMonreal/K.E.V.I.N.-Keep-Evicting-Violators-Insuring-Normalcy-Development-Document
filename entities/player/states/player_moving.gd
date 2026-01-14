extends PlayerBaseState
## Player Moving State

@export var idle_state : PlayerBaseState
#@export var interact_state : PlayerBaseState
#@export var hide_state : PlayerBaseState
#@export var die_state : PlayerBaseState

@export var move_speed : float = 300

func enter():
	super()


func physics_process(_delta: float) -> BaseState:
	var direction := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	if direction == Vector2():
		return idle_state
	
	if direction.x != 0:
		parent.animations.flip_h = direction.x < 0
	
	parent.velocity = direction.normalized() * move_speed
	parent.move_and_slide()
	
	return null
