extends InvaderBaseState

const ARRIVE_EPS := 20.0

# Stuck detection tuning
const STUCK_TIME_SEC := 0.6          # how long we tolerate no real movement
const STUCK_MOVE_EPS := 2.0          # pixels of net movement within the window
const STUCK_TARGET_PROGRESS_EPS := 0.5 # optional: minimum improvement in distance-to-target

var _stuck_time := 0.0
var _last_pos: Vector2
var _last_dist_to_target := INF
var _has_last := false

func _ensure_tracking(invader: Invader) -> void:
	if not _has_last:
		_last_pos = invader.global_position
		_last_dist_to_target = invader.global_position.distance_to(invader.target_node.global_position)
		_has_last = true

func _reset_stuck_tracking(invader: Invader) -> void:
	_stuck_time = 0.0
	_last_pos = invader.global_position
	_last_dist_to_target = invader.global_position.distance_to(invader.target_node.global_position)

func _pick_new_target(invader: Invader) -> void:
	var neighbors: Array = invader.current_node.neighbors
	if neighbors.is_empty():
		return

	# Prefer least-visited neighbors, but avoid picking the same target again if possible.
	var min_visits := INF
	for n in neighbors:
		min_visits = min(min_visits, n.visit_count)

	var candidates: Array = []
	for n in neighbors:
		if n.visit_count == min_visits and n != invader.target_node:
			candidates.append(n)

	# If everything is the same node (or only one neighbor), fall back.
	if candidates.is_empty():
		for n in neighbors:
			if n != invader.target_node:
				candidates.append(n)

	if candidates.is_empty():
		# Only possible target is the same one; nothing we can do.
		return

	invader.target_node = candidates.pick_random()
	_reset_stuck_tracking(invader)

func physics_process(delta: float) -> int:
	var invader := entity as Invader
	_ensure_tracking(invader)

	var target_pos := invader.target_node.global_position

	# Move
	invader.global_position = invader.global_position.move_toward(
		target_pos,
		invader.speed * delta
	)

	# Arrival
	if invader.global_position.distance_to(target_pos) < ARRIVE_EPS:
		invader.target_node.visit_count += 1
		invader.current_node = invader.target_node

		var neighbors: Array = invader.current_node.neighbors
		if neighbors.is_empty():
			_reset_stuck_tracking(invader)
			return InvaderBaseState.State.Moving

		var min_visits := INF
		for n in neighbors:
			min_visits = min(min_visits, n.visit_count)

		var candidates: Array = []
		for n in neighbors:
			if n.visit_count == min_visits:
				candidates.append(n)

		invader.target_node = candidates.pick_random()
		_reset_stuck_tracking(invader)

		if randi_range(0, 100) < 20:
			return InvaderBaseState.State.Scanning

		return InvaderBaseState.State.Moving

	# --- Stuck detection (oscillation / not making progress) ---
	var moved := invader.global_position.distance_to(_last_pos)
	var dist_to_target := invader.global_position.distance_to(target_pos)
	var target_progress := _last_dist_to_target - dist_to_target

	# Consider it "not really moving" if it barely moved AND isn't reducing distance meaningfully.
	var not_moving := moved < STUCK_MOVE_EPS
	var not_progressing := target_progress < STUCK_TARGET_PROGRESS_EPS

	if not_moving and not_progressing:
		_stuck_time += delta
		if _stuck_time >= STUCK_TIME_SEC:
			_pick_new_target(invader)
	else:
		# Reset timer if it is moving/progressing.
		_stuck_time = 0.0

	_last_pos = invader.global_position
	_last_dist_to_target = dist_to_target

	return InvaderBaseState.State.Moving
