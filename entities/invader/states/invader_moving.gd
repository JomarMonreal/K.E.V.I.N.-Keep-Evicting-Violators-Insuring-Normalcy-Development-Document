extends InvaderBaseState

const ARRIVE_EPS := 20.0

# If we don't reach the current target within this time, reroute.
const TARGET_TIMEOUT_SEC := 4.7

var _time_to_target: float = 0.0
var _previous_node: Node2D = null
const VISIT_INCREMENT := 4
const BACKTRACK_PENALTY := 6

func _as_node2d_array(nodes: Array) -> Array[Node2D]:
	var out: Array[Node2D] = []
	for n in nodes:
		var n2 := n as Node2D
		if n2 != null:
			out.append(n2)
	return out


func _choose_next_target(invader: Invader) -> void:
	var neighbors2d: Array[Node2D] = _as_node2d_array(invader.current_node.neighbors)
	if neighbors2d.is_empty():
		return

	var unvisited: Array[Node2D] = []
	for n in neighbors2d:
		if int(n.visit_count) == 0:
			unvisited.append(n)

	if _previous_node != null and neighbors2d.size() > 1:
		var filtered: Array[Node2D] = []
		for n in unvisited:
			if n != _previous_node:
				filtered.append(n)
		if not filtered.is_empty():
			unvisited = filtered

	if not unvisited.is_empty():
		var next_u: Node2D = unvisited.pick_random()
		var inc_u := VISIT_INCREMENT
		if _previous_node != null and next_u == _previous_node:
			inc_u += BACKTRACK_PENALTY
		next_u.visit_count += inc_u
		invader.target_node = next_u
		_time_to_target = 0.0
		return

	var pool: Array[Node2D] = neighbors2d
	if _previous_node != null and neighbors2d.size() > 1:
		var no_back: Array[Node2D] = []
		for n in neighbors2d:
			if n != _previous_node:
				no_back.append(n)
		if not no_back.is_empty():
			pool = no_back

	var min_visits: int = int(pool[0].visit_count)
	for n in pool:
		min_visits = min(min_visits, int(n.visit_count))

	var candidates: Array[Node2D] = []
	for n in pool:
		if int(n.visit_count) == min_visits:
			candidates.append(n)

	var next: Node2D = candidates.pick_random()
	var inc := VISIT_INCREMENT
	if _previous_node != null and next == _previous_node:
		inc += BACKTRACK_PENALTY
	next.visit_count += inc

	invader.target_node = next
	_time_to_target = 0.0

func physics_process(delta: float) -> int:
	var invader: Invader = entity as Invader

	# Ensure target
	if invader.target_node == null:
		_choose_next_target(invader)
		return InvaderBaseState.State.Moving

	var target_node2d := invader.target_node as Node2D
	if target_node2d == null:
		invader.target_node = null
		_choose_next_target(invader)
		return InvaderBaseState.State.Moving

	# Move
	var target_pos: Vector2 = target_node2d.global_position
	invader.global_position = invader.global_position.move_toward(target_pos, invader.speed * delta)

	# Timeout reroute (doesn't depend on movement)
	_time_to_target += delta
	if _time_to_target >= TARGET_TIMEOUT_SEC:
		_choose_next_target(invader)
		return InvaderBaseState.State.Moving

	# Arrival
	if invader.global_position.distance_to(target_pos) < ARRIVE_EPS:
		_previous_node = invader.current_node as Node2D
		invader.current_node = invader.target_node
		_choose_next_target(invader)

		if randi_range(0, 100) < 20:
			return InvaderBaseState.State.Scanning

	return InvaderBaseState.State.Moving
