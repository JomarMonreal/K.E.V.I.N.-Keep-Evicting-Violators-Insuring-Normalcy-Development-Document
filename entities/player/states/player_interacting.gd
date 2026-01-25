extends PlayerBaseState
## Player Interacting State

@export var idle_state : PlayerBaseState


func enter():
	super()
	parent.velocity = Vector2()


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_pressed("place_trap"):
		return idle_state

	return null


func process(_delta: float) -> BaseState:
	return null

func physics_process(_delta: float) -> BaseState:
	parent.move_and_slide()
	
	return null
