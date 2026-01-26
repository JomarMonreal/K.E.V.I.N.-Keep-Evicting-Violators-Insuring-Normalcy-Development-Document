extends InvaderBaseState
class_name InvaderTrappedState

@export var skin: float = 2.0

var _dir: Vector2 = Vector2.LEFT
var _remaining: float = 0.0
var _old_modulate: Color

func enter() -> void:
	var invader := entity as Invader
	AudioManager.create_2d_audio_at_location(invader.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.INVADER_TRAP_TRIGGERED)
	if invader.current_fear >= invader.maxFear:
		invader.states.change_state(InvaderBaseState.State.Leaving)
		return

	_dir = invader.scare_direction
	if _dir.length_squared() < 0.0001:
		_dir = Vector2.LEFT
	_dir = _dir.normalized()

	_remaining = maxf(0.0, invader.trap_redirect_distance)

	invader.linear_velocity = Vector2.ZERO
	invader.angular_velocity = 0.0

	_old_modulate = invader.sprite.modulate
	invader.sprite.modulate = Color(1.0, 0.0, 0.0, _old_modulate.a) # red, keep alpha

func exit() -> void:
	var invader := entity as Invader
	invader.sprite.modulate = _old_modulate

func physics_process(delta: float) -> int:
	var invader := entity as Invader

	if _remaining <= 0.001:
		invader.scare_direction = Vector2.ZERO
		return InvaderBaseState.State.Moving

	var step := minf(_remaining, invader.speed * delta)
	if step <= 0.0:
		invader.scare_direction = Vector2.ZERO
		return InvaderBaseState.State.Moving

	var from := invader.global_position
	var to := from + _dir * step

	var space_state := invader.get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [invader]
	query.collision_mask = invader.collision_mask
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var hit := space_state.intersect_ray(query)
	if hit:
		invader.global_position = hit.position - _dir * skin
		invader.scare_direction = Vector2.ZERO
		return InvaderBaseState.State.Moving

	invader.global_position = to
	_remaining -= step

	return InvaderBaseState.State.Trapped
