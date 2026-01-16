extends Node
class_name TrapArea

@export var scare_factor: int = 25
@export var scare_direction: Vector2 = Vector2.LEFT
@export var scare_distance: float = 300.0
@export var preview_speed: float = 250.0 # pixels per second

# If true, randomize among the four cardinal directions.
# If false, pick any random unit vector.
@export var randomize_cardinal_only: bool = true

@onready var scare_ghost: Node2D = $ScareGhost

var start_ghost_preview: bool = false
var _preview_running: bool = false
var _ghost_start_pos: Vector2
var _preview_tween: Tween

@export var has_trap: bool = false

func _ready() -> void:
	scare_ghost.visible = false
	_ghost_start_pos = scare_ghost.position
	_randomize_scare_direction()


func _process(_delta: float) -> void:
	if start_ghost_preview and not _preview_running:
		_start_preview()

func _randomize_scare_direction() -> void:
	if randomize_cardinal_only:
		var dirs := [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
		scare_direction = dirs[randi() % dirs.size()]
	else:
		# Random unit vector (avoid zero-length)
		scare_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		if scare_direction.length_squared() == 0.0:
			scare_direction = Vector2.LEFT

func _start_preview() -> void:
	_preview_running = true
	scare_ghost.visible = true
	scare_ghost.position = _ghost_start_pos

	var dir := scare_direction
	if dir.length_squared() == 0.0:
		dir = Vector2.LEFT
	dir = dir.normalized()

	var target := _ghost_start_pos + dir * scare_distance
	var duration := maxf(0.001, scare_distance / maxf(1.0, preview_speed))

	if is_instance_valid(_preview_tween):
		_preview_tween.kill()

	_preview_tween = create_tween()
	_preview_tween.tween_property(scare_ghost, "position", target, duration)
	_preview_tween.finished.connect(func() -> void:
		scare_ghost.visible = false
		scare_ghost.position = _ghost_start_pos
		_preview_running = false
		start_ghost_preview = false
	)

func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		start_ghost_preview = true
		
	elif body is Invader and has_trap:
		# Apply trap effects to invader
		body.scare_direction = scare_direction
		body.states.change_state(InvaderBaseState.State.Trapped)
		has_trap = false

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		start_ghost_preview = false
