extends InvaderBaseState
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	var invader := entity as Invader
	return InvaderBaseState.State.Moving
	
