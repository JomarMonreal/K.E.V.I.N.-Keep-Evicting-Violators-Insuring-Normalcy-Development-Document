class_name Player
extends CharacterBody2D

const MAX_SANITY : float = 100.0
@onready var sanity : float = 0

@export var animations : AnimatedSprite2D
@export var crafting_manager: CraftingManager

@export_group("Shader Parameters")
@export var scared_flash_color : Color

@onready var scared_flash_modifier : float = 0.0

@export_group("")
@export var night_manager : NightManager

@onready var state_manager : PlayerStateManager = $PlayerStateManager
@onready var is_planning : bool = true

@export var trap_scene: PackedScene


func _ready() -> void:
	state_manager.init(self)
	
	animations.material.set_shader_parameter("flash_color", scared_flash_color)
	animations.material.set_shader_parameter("flash_modifier", 0.0)
	
	night_manager.has_started_planning.connect(_on_planning)
	night_manager.has_started_invading.connect(_on_invading)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("place_trap"):
		var item_resource: Item = load("res://resources/items/materials/sample_item_1.tres")
		if crafting_manager.inventory.less_item(item_resource, 10):
			var trap = trap_scene.instantiate() as TrapArea
			trap.global_position = global_position
			get_tree().root.add_child(trap)
			print("TRAP PLACED")
	state_manager.input(event)


func _process(delta: float) -> void:
	state_manager.process(delta)


func _physics_process(delta: float) -> void:
	state_manager.physics_process(delta)


func _on_planning():
	is_planning = true


func _on_invading():
	is_planning = false


#TODO: SFX - moving, interacting, hiding, dead
