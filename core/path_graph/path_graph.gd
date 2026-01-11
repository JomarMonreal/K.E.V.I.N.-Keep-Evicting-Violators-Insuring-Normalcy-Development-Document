extends Node
class_name PathGraph

@onready var background_sprite: Sprite2D = $Background

func _ready() -> void:
	if Engine.is_editor_hint():
		_refresh_node_roles()
	else:
		print("Background node:", get_node_or_null("Background"))

func _refresh_node_roles() -> void:
	if not Engine.is_editor_hint():
		return

	# Update only PathNodes under this PathGraph in the scene tree.
	for n in get_tree().get_nodes_in_group("path_nodes"):
		if n is PathNode and is_ancestor_of(n):
			(n as PathNode)._editor_update_role()

func get_nodes_by_role(role: PathNode.Role) -> Array[PathNode]:
	var out: Array[PathNode] = []
	for n in get_children():
		if n is PathNode and (n as PathNode).role == role:
			out.append(n)
	return out

func find_path(start: PathNode, goal: PathNode) -> Array[PathNode]:
	var empty: Array[PathNode] = []
	if start == null or goal == null:
		return empty
	if start == goal:
		return empty # You can also return [start] if you prefer.

	# --- A* bookkeeping ---
	var open: Array[PathNode] = [start]
	var came_from: Dictionary = {} # PathNode -> PathNode

	var g_score: Dictionary = { start: 0.0 }  # cost from start
	var f_score: Dictionary = { start: start.global_position.distance_to(goal.global_position) }

	while open.size() > 0:
		var current := _pop_lowest_f(open, f_score)
		if current == goal:
			return _reconstruct_path(came_from, start, goal)

		# IMPORTANT: change this line if your PathNode uses a different field/method.
		var neighbors: Array[PathNode] = (current as PathNode).neighbors

		for neighbor in neighbors:
			if neighbor == null:
				continue

			# Optional safety: keep paths inside this graph.
			if not is_ancestor_of(neighbor):
				continue

			var step_cost := current.global_position.distance_to(neighbor.global_position)
			var tentative_g := float(g_score.get(current, INF)) + step_cost

			if tentative_g < float(g_score.get(neighbor, INF)):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + neighbor.global_position.distance_to(goal.global_position)

				if not open.has(neighbor):
					open.append(neighbor)

	return empty # No path found.

func _pop_lowest_f(open: Array[PathNode], f_score: Dictionary) -> PathNode:
	var best_i := 0
	var best_f := float(f_score.get(open[0], INF))

	for i in range(1, open.size()):
		var node := open[i]
		var node_f := float(f_score.get(node, INF))
		if node_f < best_f:
			best_f = node_f
			best_i = i

	var best := open[best_i]
	open.remove_at(best_i)
	return best

func _reconstruct_path(came_from: Dictionary, start: PathNode, goal: PathNode) -> Array[PathNode]:
	var path: Array[PathNode] = []
	var current: PathNode = goal

	# Builds [goal ... start], then reverses.
	while current != start:
		path.append(current)
		if not came_from.has(current):
			return [] # Defensive: broken chain.
		current = came_from[current] as PathNode

	path.reverse()
	return path
