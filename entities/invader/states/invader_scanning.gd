extends InvaderBaseState

const MAX_SPINS: int = 3
const MAX_ANGLE_DEG: float = 270.0
const PAUSE_SECONDS: float = 1.0
const ROT_EPS: float = 0.001


# Smoothness controls
const MIN_SPIN_DURATION: float = 0.15
const MAX_SPIN_DURATION: float = 0.45

@onready var timer: Timer = $ScanDelayTimer

var _spins_left: int
var _rotating: bool = false
var _target_rotation: float = 0.0
var _ang_speed: float = 0.0  # rad/sec

func enter() -> void:
	randomize()

	timer.one_shot = true
	timer.wait_time = PAUSE_SECONDS

	_spins_left = randi_range(1, MAX_SPINS)
	_start_next_spin()

func process(delta: float) -> int:
	var invader := entity as Invader
	if not _rotating:
		return InvaderBaseState.State.Scanning

	var diff := angle_difference(invader.rotation, _target_rotation)
	var step := _ang_speed * delta

	if absf(diff) <= maxf(step, ROT_EPS):
		invader.rotation = _target_rotation
		_rotating = false
		timer.start()
	else:
		invader.rotation = invader.rotation + signf(diff) * step

	return InvaderBaseState.State.Scanning

func _start_next_spin() -> void:
	var invader = entity as Invader
	if _spins_left <= 0:
		return

	var angle_deg: float = randf_range(1.0, MAX_ANGLE_DEG) # never 0
	var angle_rad: float = deg_to_rad(angle_deg)

	# Godot 2D: positive rotation is clockwise.
	_target_rotation = invader.rotation + angle_rad

	var duration: float = randf_range(MIN_SPIN_DURATION, MAX_SPIN_DURATION)
	_ang_speed = angle_rad / max(duration, 0.001)

	_spins_left -= 1
	_rotating = true


func _on_scan_delay_timer_timeout() -> void:
	var invader = entity as Invader
	if _spins_left > 0:
		_start_next_spin()
	else:
		invader.states.change_state(InvaderBaseState.State.Moving)
		pass
