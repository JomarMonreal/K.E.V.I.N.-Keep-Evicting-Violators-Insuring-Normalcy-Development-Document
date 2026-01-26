# SpawnManager.gd (Godot 4)
extends Node
class_name SpawnManager

enum DistributionMode {
	EVEN,
	BY_AREA
}

@export var debug_logs: bool = true
@export var distribution_mode: DistributionMode = DistributionMode.EVEN

# Optional: call spawn_all automatically on _ready.
@export var auto_spawn_on_ready: bool = false
@export var auto_spawn_count: int = 0

var _spawners: Array[SimplePolygonSpawner] = []

func _ready() -> void:
	_refresh_spawners()

	if debug_logs:
		print("[SpawnManager] _ready() on ", name, " path=", get_path())
		print("[SpawnManager] spawners found=", _spawners.size())

	if auto_spawn_on_ready and auto_spawn_count > 0:
		spawn_all(auto_spawn_count)

func _refresh_spawners() -> void:
	_spawners.clear()
	for c in get_children():
		if c is SimplePolygonSpawner:
			_spawners.append(c as SimplePolygonSpawner)

func spawn_all(total_items: int) -> void:
	_refresh_spawners()

	if total_items <= 0:
		if debug_logs:
			print("[SpawnManager] spawn_all() aborted: total_items <= 0 (", total_items, ")")
		return

	if _spawners.is_empty():
		push_warning("SpawnManager: No SimplePolygonSpawner children found.")
		if debug_logs:
			print("[SpawnManager] spawn_all() aborted: no spawners")
		return

	var counts: PackedInt32Array = _allocate_counts(total_items)

	if debug_logs:
		print("[SpawnManager] spawn_all(total_items=", total_items, ") mode=", distribution_mode)
		print("[SpawnManager] allocation=", counts)

	for i in range(_spawners.size()):
		var n := counts[i]
		if n <= 0:
			continue

		var s := _spawners[i]
		if debug_logs:
			print("[SpawnManager] -> spawner#", i, " name=", s.name, " count=", n)

		s.spawn(n)

func _allocate_counts(total_items: int) -> PackedInt32Array:
	match distribution_mode:
		DistributionMode.BY_AREA:
			return _allocate_by_area(total_items)
		_:
			return _allocate_even(total_items)

func _allocate_even(total_items: int) -> PackedInt32Array:
	var n := _spawners.size()
	var out := PackedInt32Array()
	out.resize(n)
	
	@warning_ignore("integer_division")
	var base := total_items / n
	var rem := total_items % n

	# Example: 25 items, 3 spawners => base=8 rem=1 => 9/8/8
	for i in range(n):
		out[i] = base + (1 if i < rem else 0)

	return out

func _allocate_by_area(total_items: int) -> PackedInt32Array:
	var n := _spawners.size()
	var out := PackedInt32Array()
	out.resize(n)

	# Collect areas (fallback to 0 if not available).
	var areas: PackedFloat32Array = PackedFloat32Array()
	areas.resize(n)

	var sum_area := 0.0
	for i in range(n):
		var a := _get_spawner_area(_spawners[i])
		areas[i] = a
		sum_area += a

	# If we cannot get meaningful areas, fall back to even.
	if sum_area <= 0.0:
		if debug_logs:
			print("[SpawnManager] BY_AREA fallback: sum_area <= 0, using EVEN")
		return _allocate_even(total_items)

	# First pass: floor of proportional allocation.
	var assigned := 0
	var fractional: Array = [] # each entry: { "i": int, "frac": float }
	fractional.resize(n)

	for i in range(n):
		var exact := (areas[i] / sum_area) * float(total_items)
		var flo := int(floor(exact))
		out[i] = flo
		assigned += flo
		fractional[i] = { "i": i, "frac": exact - float(flo) }

	# Second pass: distribute remaining by largest fractional parts.
	var remaining := total_items - assigned
	fractional.sort_custom(func(a, b): return a["frac"] > b["frac"])

	var k := 0
	while remaining > 0:
		var idx := int(fractional[k % n]["i"])
		out[idx] += 1
		remaining -= 1
		k += 1

	return out

func _get_spawner_area(spawner: SimplePolygonSpawner) -> float:
	# We use the same triangulation approach the spawner uses.
	# This is robust and does not require editing SimplePolygonSpawner.
	var poly := _find_collision_polygon(spawner)
	if poly == null:
		return 0.0

	var verts := poly.polygon
	if verts.size() < 3:
		return 0.0

	var tri := Geometry2D.triangulate_polygon(verts)
	if tri.size() < 3:
		return 0.0

	var total := 0.0
	for i in range(0, tri.size(), 3):
		var a: Vector2 = verts[tri[i]]
		var b: Vector2 = verts[tri[i + 1]]
		var c: Vector2 = verts[tri[i + 2]]
		total += 0.5 * absf((b - a).cross(c - a))

	return total

func _find_collision_polygon(spawner: SimplePolygonSpawner) -> CollisionPolygon2D:
	for c in spawner.get_children():
		if c is CollisionPolygon2D:
			return c as CollisionPolygon2D
	return null
