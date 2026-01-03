extends BaseStateManager2
class_name InvaderStateManager

func _ready() -> void:
	states = {
		InvaderBaseState.State.Moving: $Moving,
		InvaderBaseState.State.Trapped: $Trapped,
		InvaderBaseState.State.Attacking: $Attacking,
		InvaderBaseState.State.Stealing: $Stealing,
		InvaderBaseState.State.Leaving: $Leaving,

	}

	initial_state = InvaderBaseState.State.Moving
