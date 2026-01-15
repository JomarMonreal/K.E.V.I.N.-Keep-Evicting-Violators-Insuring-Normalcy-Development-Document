class_name Player
extends CharacterBody2D

@export_file(".tscn") var main_menu : String = ""

@export var animations : AnimatedSprite2D
@onready var state_manager : PlayerStateManager = $PlayerStateManager

var is_blue = true


func _ready() -> void:
	state_manager.init(self)


func _input(event: InputEvent) -> void:
	# testing ui scene changing
	if event.is_action_pressed("ui_accept"):
		print("test ui change")
		Global.game_manager.change_ui_scene(Global.main_menu_file)


func _unhandled_input(event: InputEvent) -> void:
	state_manager.input(event)


func _process(delta: float) -> void:
	if is_blue:
		animations.animation = "idle_blue"
	else:
		animations.animation = "idle_black"

	state_manager.process(delta)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)
