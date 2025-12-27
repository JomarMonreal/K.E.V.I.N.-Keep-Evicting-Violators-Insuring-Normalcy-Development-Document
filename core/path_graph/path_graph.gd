extends Node
class_name PathGraph

@export var entrance_nodes: Array[PathNode] = [];
@export var exit_nodes: Array[PathNode] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func find_path(current: PathNode, target: PathNode) -> Array[PathNode]:
	if current == null or target == null:
		return []

	if current == target:
		return []

	var queue: Array[PathNode] = []
	var came_from: Dictionary = {}
	var visited: Dictionary = {}

	queue.append(current)
	visited[current] = true

	while queue.size() > 0:
		var node: PathNode = queue.pop_front()

		if node == target:
			break

		for neighbor in node.neighbors:
			if neighbor == null or visited.has(neighbor):
				continue
			visited[neighbor] = true
			came_from[neighbor] = node
			queue.append(neighbor)

	# No path found
	if not came_from.has(target):
		return []

	# Reconstruct path (target → current)
	var path: Array[PathNode] = []
	var step: PathNode = target

	while step != current:
		path.push_front(step)
		step = came_from[step]

	return path
