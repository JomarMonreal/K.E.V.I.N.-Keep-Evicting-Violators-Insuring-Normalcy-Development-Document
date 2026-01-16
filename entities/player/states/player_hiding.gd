extends PlayerBaseState
## Player Frozen State

@export var idle_state : PlayerBaseState
#@export var dead_state : PlayerBaseState

func process(_delta: float) -> BaseState:
	if parent.is_planning:
		return idle_state
	
	return null
