extends InvaderBaseState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	var invader := entity as Invader
	invader.global_position = invader.global_position.move_toward(invader.target_node.global_position, invader.speed * delta)
	if invader.global_position.distance_to(invader.target_node.global_position) < 1.0:
		invader.current_node = invader.target_node
		var target_neighbors = invader.target_node.neighbors.filter(func(neighbor): return neighbor != invader.current_node)
		invader.target_node = target_neighbors.pick_random()
	return InvaderBaseState.State.Moving
	
