extends Node2D

@export var bgm_options : Array[SoundEffectSettings]

@onready var bgm_timer: Timer = $BGMTimer

const MIN_WAIT_TIME = 20.0
const MAX_WAIT_TIME = 40.0

func play_random_bgm():
	var randomized : int = randi_range(0, bgm_options.size() - 1)
	
	var new_2d_audio = AudioStreamPlayer2D.new()
	add_child(new_2d_audio)
	
	new_2d_audio.stream = bgm_options[randomized].sound_effect
	new_2d_audio.volume_db = bgm_options[randomized].volume
	new_2d_audio.pitch_scale = bgm_options[randomized].pitch_scale
	new_2d_audio.pitch_scale += randf_range(-bgm_options[randomized].pitch_randomness, bgm_options[randomized].pitch_randomness)
	new_2d_audio.finished.connect(bgm_options[randomized].on_audio_finished)
	new_2d_audio.finished.connect(_on_bgm_finished)
	new_2d_audio.finished.connect(new_2d_audio.queue_free) # clear self after playing
	
	new_2d_audio.play()


func _on_bgm_finished():
	randomize_timer()


func randomize_timer():
	bgm_timer.wait_time = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	bgm_timer.start()


func _on_bgm_timer_timeout() -> void:
	play_random_bgm()
