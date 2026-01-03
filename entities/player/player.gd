class_name Player
extends CharacterBody2D

@export var animations : AnimatedSprite2D
@onready var state_manager : PlayerStateManager = $PlayerStateManager


func _ready() -> void:
	state_manager.init(self)


func _unhandled_input(event: InputEvent) -> void:
	state_manager.input(event)


func _process(delta: float) -> void:
	state_manager.process(delta)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)
