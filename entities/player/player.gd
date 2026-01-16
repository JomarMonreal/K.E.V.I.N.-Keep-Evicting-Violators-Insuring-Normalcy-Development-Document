class_name Player
extends CharacterBody2D

@export var animations : AnimatedSprite2D
@export var night_manager : NightManager
@onready var state_manager : PlayerStateManager = $PlayerStateManager

@onready var is_planning : bool = true

func _ready() -> void:
	state_manager.init(self)
	
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
