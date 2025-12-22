extends PlayerBaseState

func input(event: InputEvent) -> int:
	var player := entity as Player
		
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		return PlayerBaseState.State.Moving
		
	return PlayerBaseState.State.Idle
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	var player := entity as Player
	return PlayerBaseState.State.Idle
	
