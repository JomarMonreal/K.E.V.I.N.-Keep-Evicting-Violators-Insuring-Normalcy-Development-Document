class_name Player
extends CharacterBody2D

@export var animations : AnimatedSprite2D

@export_group("Shader Parameters")
@export var scared_flash_color : Color

@onready var scared_flash_modifier : float = 0.0

@export_group("")
@export var night_manager : NightManager

@onready var state_manager : PlayerStateManager = $PlayerStateManager

# vignette effect on camera
#@onready var camera_rect := get_viewport().get_camera_2d()
#@onready var screen_dim := get_viewport_rect().size
#@onready var vignette : ColorRect = $CanvasLayer/ColorRect

@onready var is_planning : bool = true


func _ready() -> void:
	state_manager.init(self)
	
	animations.material.set_shader_parameter("flash_color", scared_flash_color)
	animations.material.set_shader_parameter("flash_modifier", 0.0)
	
	night_manager.has_started_planning.connect(_on_planning)
	night_manager.has_started_invading.connect(_on_invading)


func _unhandled_input(event: InputEvent) -> void:
	state_manager.input(event)


func _process(delta: float) -> void:
	state_manager.process(delta)
	
	# vignette effect on camera
	#var screen_pos = camera_rect.unproject_position(global_position)
	#
	#var player_position_uv = screen_pos / screen_dim
	#vignette.material.set_shader_parameter("player_position", player_position_uv)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)


func _on_planning():
	is_planning = true


func _on_invading():
	is_planning = false


#TODO: SFX - moving, interacting, hiding, dead
