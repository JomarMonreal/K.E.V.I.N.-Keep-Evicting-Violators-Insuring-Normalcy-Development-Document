extends InvaderBaseState

var leaving_path: Array[PathNode]
var target_node: PathNode
var _old_modulate: Color

func enter() -> void:
	var invader := entity as Invader
	AudioManager.create_2d_audio_at_location(invader.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.INVADER_SCARED)
	target_node = invader.path_graph.get_nodes_by_role(PathNode.Role.ENTRANCE).pick_random()
	leaving_path = invader.path_graph.find_path(invader.current_node, target_node)
	invader.speed *= 2
	
	_old_modulate = invader.sprite.modulate
	invader.sprite.modulate = Color(1.0, 0.0, 0.0, _old_modulate.a) # red, keep alpha
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	var invader := entity as Invader
	if leaving_path.size() > 0:
		invader.global_position = invader.global_position.move_toward(leaving_path[0].global_position, invader.speed * delta)
		if invader.global_position.distance_to(leaving_path[0].global_position) < 1.0:
			leaving_path.pop_front()
	
	if leaving_path.size() == 0:
		invader.leaving_scared.emit()
		return InvaderBaseState.State.Idle
		
	return InvaderBaseState.State.Leaving
	
