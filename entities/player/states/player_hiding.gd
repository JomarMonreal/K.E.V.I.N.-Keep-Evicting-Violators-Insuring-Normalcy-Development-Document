extends PlayerBaseState
## Player Frozen State

@export var idle_state : PlayerBaseState

func enter():
	super()
	
	print("IN HIDING STATE")


func exit():
	super()
	
	print("OUT OF HIDING STATE")

func process(_delta: float) -> BaseState:
	if not parent.is_planning:
		return idle_state
	
	return null
