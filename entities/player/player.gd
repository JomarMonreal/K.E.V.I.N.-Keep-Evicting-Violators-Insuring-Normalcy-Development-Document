class_name Player
extends CharacterBody2D

const MAX_SANITY : float = 100.0
@onready var sanity : float = 0

@export var animations : AnimatedSprite2D
@export var crafting_manager: CraftingManager

@export var footsteps_audio : SoundEffectSettings
@onready var footsteps_audio_player: AudioStreamPlayer2D = $FootstepsAudio
@onready var item_detector_area: Area2D = $ItemDetector


@export_group("Shader Parameters")
@export var scared_flash_color : Color

@onready var scared_flash_modifier : float = 0.0

@export_group("")
@export var night_manager : NightManager

@onready var state_manager : PlayerStateManager = $PlayerStateManager
@onready var is_planning : bool = true

@export var trap_scene: PackedScene
@export var item_scene: PackedScene


func _ready() -> void:
	state_manager.init(self)
	
	animations.material.set_shader_parameter("flash_color", scared_flash_color)
	animations.material.set_shader_parameter("flash_modifier", 0.0)
	
	night_manager.has_started_planning.connect(_on_planning)
	night_manager.has_started_invading.connect(_on_invading)
	
	footsteps_audio_player.stream = footsteps_audio.sound_effect
	footsteps_audio_player.volume_db = footsteps_audio.volume
	footsteps_audio_player.pitch_scale = footsteps_audio.pitch_scale
	footsteps_audio_player.pitch_scale += randf_range(-footsteps_audio.pitch_randomness, footsteps_audio.pitch_randomness)
	footsteps_audio_player.finished.connect(footsteps_audio.on_audio_finished)
	footsteps_audio_player.finished.connect(footsteps_audio_player.queue_free) # clear self after playing


func _unhandled_input(event: InputEvent) -> void:
	state_manager.input(event)


func _process(delta: float) -> void:
	state_manager.process(delta)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)
	
	play_footsteps()
	
	for area in item_detector_area.get_overlapping_areas():
		if area is ItemArea:
			if Input.is_action_just_released("place_trap") and night_manager.planning_timer.time_left > 0:
				var item_resource: Item = crafting_manager.inventory.get_item_at_slot_index(crafting_manager.inventory.selected_index)
				if crafting_manager.inventory.less_item(item_resource, 1):
					var trap = trap_scene.instantiate() as TrapArea
					trap.trap_info = Constants.get_trap_for_items([area.item_info, item_resource])
					if trap.trap_info:
						trap.global_position = global_position
						get_tree().root.add_child(trap)
						AudioManager.create_2d_audio_at_location(trap.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.TRAP_PLACED)
						area.queue_free()
						print("TRAP PLACED")
					else:
						var item = item_scene.instantiate() as ItemArea
						item.item_info = item_resource
						item.global_position = global_position
						# get the item given items
						get_tree().root.add_child(item)
						AudioManager.create_2d_audio_at_location(item.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.TRAP_PLACED)
						print("ITEM PLACED")
				return
					
			if Input.is_action_just_released("interact") and night_manager.planning_timer.time_left > 0:
				crafting_manager.inventory.store_item(area.item_info, 1)
				area.queue_free()
				return

		if area is TrapArea:
			if Input.is_action_just_released("interact") and night_manager.planning_timer.time_left > 0:
				for item in area.trap_info.items:
					crafting_manager.inventory.store_item(item, 1)
				area.queue_free()
			return

	if Input.is_action_just_released("place_trap") and night_manager.planning_timer.time_left > 0:
		var item_resource: Item = crafting_manager.inventory.get_item_at_slot_index(crafting_manager.inventory.selected_index)
		if crafting_manager.inventory.less_item(item_resource, 1):
			var item = item_scene.instantiate() as ItemArea
			item.item_info = item_resource
			item.global_position = global_position
			# get the item given items
			get_tree().root.add_child(item)
			AudioManager.create_2d_audio_at_location(item.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.TRAP_PLACED)
			print("ITEM PLACED")
	return


func _on_planning():
	is_planning = true


func _on_invading():
	is_planning = false


func play_footsteps():
	if is_instance_valid(footsteps_audio_player):
		if velocity != Vector2.ZERO:
			if not footsteps_audio_player.playing:
				footsteps_audio_player.play()
		else:
			footsteps_audio_player.stop()

func _on_killed_hurtbox_area_entered(area: Area2D) -> void:
	print(area)
	if area.get_parent() and area.get_parent() is Invader:
		print("KILLED")
		EventListener.player_killed.emit()
	pass # Replace with function body.


func _on_sanity_hurtbox_area_entered(area: Area2D) -> void:
	print(area)
	if area.get_parent() and area.get_parent() is Invader:
		print("SCARED")
		sanity += 10
