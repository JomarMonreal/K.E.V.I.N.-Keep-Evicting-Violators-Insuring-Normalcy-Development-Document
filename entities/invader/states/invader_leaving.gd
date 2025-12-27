extends InvaderBaseState

var leaving_path: Array[PathNode]

func enter() -> void:
	var invader := entity as Invader
	leaving_path = invader.path_graph.find_path(invader.current_node, invader.path_graph.exit_nodes.pick_random())
	invader.speed = 500
	print(invader.current_node,  invader.path_graph.exit_nodes.pick_random(), leaving_path)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	var invader := entity as Invader
	if leaving_path.size() > 0:
		invader.global_position = invader.global_position.move_toward(leaving_path[0].global_position, invader.speed * delta)
		if invader.global_position.distance_to(leaving_path[0].global_position) < 1.0:
			leaving_path.pop_front()
	return InvaderBaseState.State.Leaving
	
