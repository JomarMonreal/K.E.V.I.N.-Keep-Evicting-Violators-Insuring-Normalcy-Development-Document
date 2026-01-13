extends CharacterBody2D

const MAX_SPINS: int = 3
const MAX_ANGLE_DEG: float = 270.0
const PAUSE_SECONDS: float = 1.0

@onready var timer: Timer = $ScanDelayTimer

var _spins_left: int = 0
var _is_spinning: bool = false

func _ready() -> void:
	randomize()

	# Configure the timer once.
	timer.one_shot = true
	timer.wait_time = PAUSE_SECONDS

	# Decide how many times to rotate (1..3).
	_spins_left = randi_range(1, MAX_SPINS)

	# Start the sequence immediately.
	_is_spinning = true
	_do_one_spin_then_pause()

func _process(_delta: float) -> void:
	# Nothing to do per-frame; the timer drives the pauses.
	pass

func _do_one_spin_then_pause() -> void:
	if _spins_left <= 0:
		_is_spinning = false
		return

	# Godot 2D: positive rotation is clockwise.
	var angle_deg: float = randf_range(0.0, MAX_ANGLE_DEG)
	global_rotation += deg_to_rad(angle_deg)

	_spins_left -= 1

	# Pause 1 second before the next spin (if any).
	timer.start()

func _on_scan_delay_timeout() -> void:
	if not _is_spinning:
		return

	if _spins_left > 0:
		_do_one_spin_then_pause()
	else:
		_is_spinning = false
		# Done. Put whatever comes next here (e.g., start scanning).
