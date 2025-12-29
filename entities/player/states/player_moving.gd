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
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction == Vector2():
		return idle_state
	
	if direction.x != 0:
		parent.animations.flip_h = direction.x < 0
	
	parent.velocity = direction.normalized() * move_speed
	parent.move_and_slide()
	
	return null
