extends PlayerBaseState
## Player Idle State

@export var moving_state : PlayerBaseState
#@export var interact_state : PlayerBaseState
#@export var hide_state : PlayerBaseState
#@export var die_state : PlayerBaseState


func enter():
	super()
	parent.velocity = Vector2()


func input(_event: InputEvent) -> BaseState:
	if (
		Input.is_action_just_pressed("ui_left")
		or Input.is_action_just_pressed("ui_right")
		or Input.is_action_just_pressed("ui_up")
		or Input.is_action_just_pressed("ui_down")
	):
		return moving_state
	return null


func physics_process(_delta: float) -> BaseState:
	parent.move_and_slide()
	return null
