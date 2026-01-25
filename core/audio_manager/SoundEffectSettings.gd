class_name SoundEffectSettings
extends Resource
## Setup from Aarimous https://youtu.be/Egf2jgET3nQ?si=IOaVu3T54FryzPEM

enum SOUND_EFFECT_TYPE {
	# a collection of all used SFX in game
	BUTTON_CLICK,
	VICTORY_ENDING,
	INSANITY_ENDING,
	DEATH_ENDING,
	PLAYER_WALKING,
	PLAYER_SCARED,
	INVADER_WALKING,
	INVADER_TRAP_TRIGGERED,
	INVADER_SPOT,
	INVADER_SCARED,
	ITEM_COLLECTED,
	TRAP_COLLECTED,
	TRAP_PLACED,
	TRAP_CRAFTED,
}

@export_range(0, 10) var limit : int = 5
@export var type : SOUND_EFFECT_TYPE
@export var sound_effect : AudioStream
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0, 0.01) var pitch_scale : float = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness : float = 0.0

var audio_count : int = 0


func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)


func has_open_limit() -> bool:
	return audio_count < limit


func on_audio_finished():
	change_audio_count(-1)
