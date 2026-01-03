extends Camera2D
class_name ArrayTargetCamera2D

@export var targets: Array[NodePath] = []
@export_range(0, 1024, 1) var target_index: int = 0

# Higher = snappier. Lower = floatier.
@export_range(0.0, 30.0, 0.1) var follow_speed: float = 8.0

var _target: Node2D = null

func _ready() -> void:
	_resolve_target()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_camera"):
		_cycle_target(1)

func _process(delta: float) -> void:
	if _target == null:
		_resolve_target()
		return

	var t: float = 1.0 - exp(-follow_speed * delta)
	var desired_pos: Vector2 = _target.global_position + offset
	global_position = global_position.lerp(desired_pos, t)

func set_target_index(value: int) -> void:
	target_index = value
	_resolve_target()

func _cycle_target(step: int) -> void:
	if targets.is_empty():
		return
	target_index = (target_index + step) % targets.size()
	_resolve_target()

func _resolve_target() -> void:
	_target = null

	if targets.is_empty():
		return
	if target_index < 0 or target_index >= targets.size():
		return

	var path: NodePath = targets[target_index]
	if path.is_empty():
		return

	var n: Node = get_node_or_null(path)
	_target = n as Node2D
