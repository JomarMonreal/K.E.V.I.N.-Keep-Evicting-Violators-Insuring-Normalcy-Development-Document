extends InvaderBaseState

func physics_process(delta: float) -> int:
	var invader := entity as Invader

	invader.global_position = invader.global_position.move_toward(
		invader.target_node.global_position,
		invader.speed * delta
	)

	if invader.global_position.distance_to(invader.target_node.global_position) < 1.0:
		# We arrived.
		invader.target_node.visit_count += 1
		invader.current_node = invader.target_node

		var neighbors: Array = invader.current_node.neighbors
		if neighbors.is_empty():
			return InvaderBaseState.State.Moving # nowhere to go

		# Find the minimum visit_count among neighbors.
		var min_visits := INF
		for n in neighbors:
			min_visits = min(min_visits, n.visit_count)

		# Collect all neighbors with that minimum (tie-break randomly).
		var candidates: Array = []
		for n in neighbors:
			if n.visit_count == min_visits:
				candidates.append(n)

		invader.target_node = candidates.pick_random()

	return InvaderBaseState.State.Moving
