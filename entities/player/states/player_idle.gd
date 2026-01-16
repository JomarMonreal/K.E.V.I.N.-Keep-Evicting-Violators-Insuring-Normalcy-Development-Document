extends PlayerBaseState
## Player Idle State

@export var moving_state : PlayerBaseState
#@export var interact_state : PlayerBaseState
@export var hiding_state : PlayerBaseState


func enter():
	super()
	parent.velocity = Vector2()


func input(_event: InputEvent) -> BaseState:
	if parent.velocity != Vector2.ZERO:
		return moving_state

	
	return null


func process(_delta: float) -> BaseState:
	if not parent.is_planning:
		return hiding_state
	
	return null

func physics_process(_delta: float) -> BaseState:
	parent.move_and_slide()
	
	return null
