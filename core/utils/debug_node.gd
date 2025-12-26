# NeighborLines2D.gd (Godot 4.x)
@tool
extends Sprite2D
class_name NeighborLines2D

@export var line_color: Color = Color.WHITE:
	set(v):
		line_color = v
		queue_redraw()

@export_range(0.5, 20.0, 0.5) var line_width: float = 2.0:
	set(v):
		line_width = v
		queue_redraw()

var _syncing: bool = false
var _neighbors: Array[NeighborLines2D] = []

@export var neighbors: Array[NeighborLines2D]:
	get:
		return _neighbors
	set(value):
		_set_neighbors(value)

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_ALWAYS
		set_process(true)
	queue_redraw()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	for n in _neighbors:
		if n == null or not is_instance_valid(n):
			continue
		draw_line(Vector2.ZERO, to_local(n.global_position), line_color, line_width, true)

# --- Public helpers (optional, but nice) ---

func add_neighbor(n: NeighborLines2D) -> void:
	if n == null or n == self:
		return
	var v := _neighbors.duplicate()
	if not v.has(n):
		v.append(n)
	neighbors = v

func remove_neighbor(n: NeighborLines2D) -> void:
	if n == null:
		return
	var v := _neighbors.duplicate()
	v.erase(n)
	neighbors = v

# --- Core logic ---

func _set_neighbors(value: Array[NeighborLines2D]) -> void:
	if _syncing:
		_neighbors = _normalize(value)
		queue_redraw()
		return

	var old := _neighbors.duplicate()
	var neu := _normalize(value)

	_neighbors = neu

	# Added: ensure reciprocal add
	for n in neu:
		if n == null or not is_instance_valid(n) or n == self:
			continue
		if not old.has(n):
			n._mirror_add(self)

	# Removed: ensure reciprocal remove
	for n in old:
		if n == null or not is_instance_valid(n) or n == self:
			continue
		if not neu.has(n):
			n._mirror_remove(self)

	queue_redraw()

func _mirror_add(other: NeighborLines2D) -> void:
	if other == null or other == self:
		return
	if _neighbors.has(other):
		return
	_syncing = true
	var v := _neighbors.duplicate()
	v.append(other)
	neighbors = v # goes through setter, but _syncing blocks ping-pong
	_syncing = false

func _mirror_remove(other: NeighborLines2D) -> void:
	if other == null:
		return
	if not _neighbors.has(other):
		return
	_syncing = true
	var v := _neighbors.duplicate()
	v.erase(other)
	neighbors = v
	_syncing = false

func _normalize(list: Array[NeighborLines2D]) -> Array[NeighborLines2D]:
	var out: Array[NeighborLines2D] = []
	for n in list:
		if n == null or not is_instance_valid(n):
			continue
		if n == self:
			continue
		if out.has(n):
			continue
		out.append(n)
	return out
