# SimplePolygonSpawner.gd (Godot 4) - with debug prints
extends Area2D
class_name SimplePolygonSpawner

@export var spawn_scene: PackedScene
@export var spawn_parent: NodePath

# Toggle to silence prints without deleting them.
@export var debug_logs: bool = true

@onready var _poly: CollisionPolygon2D = _find_poly()

var _verts: PackedVector2Array
var _tri: PackedInt32Array
var _cdf: PackedFloat32Array
var _total_area: float = 0.0

func _ready() -> void:
	randomize()

	if debug_logs:
		print("[Spawner] _ready() on ", name, " path=", get_path())
		print("[Spawner] spawn_scene=", spawn_scene)
		print("[Spawner] spawn_parent path=", spawn_parent)

	_build_cache()

func spawn(count: int = 1) -> void:
	if spawn_scene == null:
		push_warning("SimplePolygonSpawner: spawn_scene is not set.")
		if debug_logs:
			print("[Spawner] spawn() aborted: spawn_scene is null")
		return

	if _poly == null or _total_area <= 0.0:
		push_warning("SimplePolygonSpawner: Missing/invalid CollisionPolygon2D.")
		if debug_logs:
			print("[Spawner] spawn() aborted: _poly=", _poly, " _total_area=", _total_area)
		return

	var parent: Node = _get_parent_node()

	if debug_logs:
		print("[Spawner] spawn(count=", count, ") parent=", parent.name, " path=", parent.get_path())
		print("[Spawner] pre-children=", parent.get_child_count())

	for idx in range(count):
		var p: Vector2 = _random_point_global()
		var inst: Node = spawn_scene.instantiate()
		parent.add_child(inst)

		if inst is Node2D:
			(inst as Node2D).global_position = p

		if debug_logs:
			var inst_name: String = ""
			if inst.name != "":
				inst_name = inst.name
			else:
				inst_name = inst.get_class()			
			var pos := (inst as Node2D).global_position if inst is Node2D else Vector2.INF
			print("[Spawner]  #", idx, " spawned=", inst_name, " global_pos=", pos)

	if debug_logs:
		print("[Spawner] post-children=", parent.get_child_count())
		print("[Spawner] children list=", parent.get_children())

func _find_poly() -> CollisionPolygon2D:
	for c in get_children():
		if c is CollisionPolygon2D:
			if debug_logs:
				print("[Spawner] Found CollisionPolygon2D child: ", c.name, " path=", c.get_path())
			return c as CollisionPolygon2D
	if debug_logs:
		print("[Spawner] No CollisionPolygon2D child found under ", name)
	return null

func _get_parent_node() -> Node:
	if spawn_parent != NodePath():
		var n := get_node_or_null(spawn_parent)
		if n != null:
			return n
		if debug_logs:
			print("[Spawner] spawn_parent invalid: ", spawn_parent, " (falling back)")

	return get_tree().current_scene if get_tree() and get_tree().current_scene else self

func _build_cache() -> void:
	if _poly == null:
		if debug_logs:
			print("[Spawner] _build_cache() aborted: _poly is null")
		return

	_verts = _poly.polygon
	if debug_logs:
		print("[Spawner] Polygon verts=", _verts.size())

	if _verts.size() < 3:
		if debug_logs:
			print("[Spawner] _build_cache() aborted: polygon has < 3 verts")
		return

	_tri = Geometry2D.triangulate_polygon(_verts)
	if debug_logs:
		print("[Spawner] Tri indices=", _tri.size(), " (triangles=", int(_tri.size() / 3), ")")

	if _tri.size() < 3:
		if debug_logs:
			print("[Spawner] _build_cache() aborted: triangulate_polygon returned < 3 indices")
		return

	_cdf = PackedFloat32Array()
	_cdf.resize(_tri.size() / 3)

	_total_area = 0.0
	var t: int = 0
	for i in range(0, _tri.size(), 3):
		var a: Vector2 = _verts[_tri[i]]
		var b: Vector2 = _verts[_tri[i + 1]]
		var c: Vector2 = _verts[_tri[i + 2]]

		var area: float = _triangle_area(a, b, c)
		_total_area += area
		_cdf[t] = _total_area

		if debug_logs and t < 5:
			print("[Spawner]  tri#", t, " area=", area, " cdf=", _cdf[t])

		t += 1

	if debug_logs:
		print("[Spawner] Total area=", _total_area)
		print("[Spawner] Polygon global_transform=", _poly.global_transform)

func _triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * absf((b - a).cross(c - a))

func _random_point_global() -> Vector2:
	var r: float = randf() * _total_area
	var ti: int = 0
	while ti < _cdf.size() and r > _cdf[ti]:
		ti += 1
	ti = clamp(ti, 0, _cdf.size() - 1)

	var base: int = ti * 3
	var a: Vector2 = _verts[_tri[base]]
	var b: Vector2 = _verts[_tri[base + 1]]
	var c: Vector2 = _verts[_tri[base + 2]]

	var u: float = randf()
	var v: float = randf()
	if u + v > 1.0:
		u = 1.0 - u
		v = 1.0 - v

	var local: Vector2 = a + u * (b - a) + v * (c - a)
	var global: Vector2 = _poly.global_transform * local

	if debug_logs:
		print("[Spawner] point tri#", ti, " r=", r, " u=", u, " v=", v, " local=", local, " global=", global)

	return global
