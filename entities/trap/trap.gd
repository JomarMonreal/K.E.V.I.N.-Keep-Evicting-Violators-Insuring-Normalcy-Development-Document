extends Node
class_name Trap

@export var scare_factor: int = 5
@export var scare_direction: Vector2 = Vector2.LEFT
@export var scare_distance: float = 100.0
@export var preview_speed: float = 250.0 # pixels per second

@onready var scare_ghost: Node2D = $ScareGhost

var start_ghost_preview: bool = false
var _preview_running: bool = false
var _ghost_start_pos: Vector2
var _preview_tween: Tween

func _ready() -> void:
	scare_ghost.visible = false
	_ghost_start_pos = scare_ghost.position

func _process(_delta: float) -> void:
	if start_ghost_preview and not _preview_running:
		_start_preview()

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
		# Optional: reset/hide when done
		scare_ghost.visible = false
		scare_ghost.position = _ghost_start_pos
		_preview_running = false
		start_ghost_preview = false
	)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		start_ghost_preview = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		start_ghost_preview = false
	pass # Replace with function body.
