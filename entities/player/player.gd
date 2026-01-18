class_name Player
extends CharacterBody2D

@export var animations : AnimatedSprite2D

@export_group("Shader Parameters")
@export var scared_flash_color : Color
@export var scared_flash_modifier : float

@export_group("")
@export var night_manager : NightManager
@onready var state_manager : PlayerStateManager = $PlayerStateManager

@onready var is_planning : bool = true

func _ready() -> void:
	state_manager.init(self)
	
	animations.material.set_shader_parameter("flash_modifier", 0.0)
	
	night_manager.has_started_planning.connect(_on_planning)
	night_manager.has_started_invading.connect(_on_invading)


func _unhandled_input(event: InputEvent) -> void:
	state_manager.input(event)


func _process(delta: float) -> void:
	state_manager.process(delta)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)


func _on_planning():
	is_planning = true
	print("planning!")


func _on_invading():
	is_planning = false
	print("hiding!")


#TODO: SFX - moving, interacting, hiding, dead
