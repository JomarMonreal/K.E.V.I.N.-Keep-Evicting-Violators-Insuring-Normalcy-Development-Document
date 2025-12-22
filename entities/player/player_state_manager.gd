extends BaseStateManager
class_name PlayerStateManager

func _ready() -> void:
	states = {
		PlayerBaseState.State.Idle: $Idle,
		PlayerBaseState.State.Moving: $Moving,
		PlayerBaseState.State.Interacting: $Interacting,
		PlayerBaseState.State.Freezing: $Freezing,
		PlayerBaseState.State.Dead: $Dead,
	}

	initial_state = PlayerBaseState.State.Idle
