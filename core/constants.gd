extends Node

const SCENE_PATHS : Dictionary = {
	"main_menu": "uid://cmryqnwtmepne",
	"night_start": "uid://cecg0rv3tntcx",
	"night_scene": "uid://cdm3l21spj67o",
	"victory_screen": "uid://cbyp772858yh5",
	"insane_screen": "uid://b218ej54v6rhf",
	"death_screen": "uid://djjktb1vjb1oj",
}

const ITEMS: Dictionary = {
	"bucket": "uid://sdgxjc41a8d5",
	"egg": "uid://besjquie6mlc3",
	"glue": "uid://4l5lobts7lqa",
	"marbles": "uid://bxpmes7vgqn0a",
	"nails": "uid://bjglw6aaj734t",
	"rope": "uid://coyko3jh22uu6",
}

const TRAPS: Dictionary = {
	"egg_splash": "uid://44hofs257682",
	"flour_bomb": "uid://ov8w8pm2q1md",
	"marble_slip": "uid://bi62roxjrtxk7",
	"nail_bed": "uid://cdn518f7dhrki",
	"sticky_escape": "uid://c1ljojrs1k5nw",
}

var _trap_cache: Dictionary = {} # key: String (trap key), value: Trap

func get_trap_for_items(provided_items: Array[Item]) -> Trap:
	var have := _count_items_by_name(provided_items)

	for trap_key in TRAPS.keys():
		var trap := _get_trap_cached(trap_key)
		if trap == null:
			continue
		if _trap_matches(trap, have):
			return trap

	return null

func _get_trap_cached(trap_key: String) -> Trap:
	if _trap_cache.has(trap_key):
		return _trap_cache[trap_key] as Trap

	var uid: String = TRAPS.get(trap_key, "") as String
	if uid.is_empty():
		return null

	var res: Resource = load(uid)
	if res == null or res is not Trap:
		push_error("Constants: trap load failed or wrong type. key=%s uid=%s" % [trap_key, uid])
		return null

	var trap: Trap = res as Trap
	_trap_cache[trap_key] = trap
	return trap

func _trap_matches(trap: Trap, have: Dictionary) -> bool:
	var need := _count_items_by_name(trap.items)
	for k in need.keys():
		if not have.has(k) or int(have[k]) < int(need[k]):
			return false
	return true

func _count_items_by_name(items: Array[Item]) -> Dictionary:
	var out: Dictionary = {}
	for it in items:
		if it == null:
			continue
		var key := it.item_name
		out[key] = int(out.get(key, 0)) + 1
	return out
