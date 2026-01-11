@tool
extends Sprite2D
class_name PathNode

var visit_count := 0

@export var line_color: Color = Color.WHITE:
	set(v):
		line_color = v
		queue_redraw()

@export_range(0.5, 20.0, 0.5) var line_width: float = 2.0:
	set(v):
		line_width = v
		queue_redraw()

enum Role { NONE, ENTRANCE, EXIT, ITEM }

@export var role: Role = Role.NONE:
	set(v):
		role = v
		_apply_role_modulate()

var _syncing := false
var _neighbors: Array[PathNode] = []


@export var neighbors: Array[PathNode]:
	get:
		return _neighbors
	set(value):
		_set_neighbors(value)

func _enter_tree() -> void:
	# Editor: show + keep redrawing so lines update while moving nodes.
	if Engine.is_editor_hint():
		visible = true
		process_mode = Node.PROCESS_MODE_ALWAYS
		set_process(true)
		_apply_role_modulate()
		queue_redraw()
		return

	# Runtime: hide sprite and prevent line drawing.
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)
	queue_redraw()

func _ready() -> void:
	visit_count = 0
	if Engine.is_editor_hint():
		_apply_role_modulate()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	for n in _neighbors:
		if n == null or not is_instance_valid(n):
			continue
		draw_line(Vector2.ZERO, to_local(n.global_position), line_color, line_width, true)

func _apply_role_modulate() -> void:
	if not Engine.is_editor_hint():
		return

	match role:
		Role.ENTRANCE: modulate = Color(1, 1, 0)
		Role.EXIT:     modulate = Color(1, 0, 0)
		Role.ITEM:     modulate = Color(1, 0, 1)
		_:             modulate = Color(1, 1, 1)
# --- Public helpers (optional) ---

func add_neighbor(n: PathNode) -> void:
	if n == null or n == self:
		return
	var v := _neighbors.duplicate()
	if not v.has(n):
		v.append(n)
	neighbors = v

func remove_neighbor(n: PathNode) -> void:
	if n == null:
		return
	var v := _neighbors.duplicate()
	v.erase(n)
	neighbors = v

# --- Core logic (unchanged) ---

func _set_neighbors(value: Array[PathNode]) -> void:
	if _syncing:
		_neighbors = _normalize(value)
		queue_redraw()
		return

	var old := _neighbors.duplicate()
	var neu := _normalize(value)

	_neighbors = neu

	for n in neu:
		if n == null or not is_instance_valid(n) or n == self:
			continue
		if not old.has(n):
			n._mirror_add(self)

	for n in old:
		if n == null or not is_instance_valid(n) or n == self:
			continue
		if not neu.has(n):
			n._mirror_remove(self)

	queue_redraw()

func _mirror_add(other: PathNode) -> void:
	if other == null or other == self:
		return
	if _neighbors.has(other):
		return
	_syncing = true
	var v := _neighbors.duplicate()
	v.append(other)
	neighbors = v
	_syncing = false

func _mirror_remove(other: PathNode) -> void:
	if other == null:
		return
	if not _neighbors.has(other):
		return
	_syncing = true
	var v := _neighbors.duplicate()
	v.erase(other)
	neighbors = v
	_syncing = false

func _normalize(list: Array[PathNode]) -> Array[PathNode]:
	var out: Array[PathNode] = []
	for n in list:
		if n == null or not is_instance_valid(n):
			continue
		if n == self:
			continue
		if out.has(n):
			continue
		out.append(n)
	return out
