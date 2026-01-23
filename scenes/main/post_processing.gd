extends CanvasLayer

@export_group("Vignette Parameters")
@export var vignette_color : Color = Color(0.42, 0.0, 0.051, 0.0)
@onready var vignette_intensity : float = 0.0

@onready var screen_dimensions := Vector2(get_viewport().size)
@onready var camera : Camera2D = $".."
@onready var vignette : ColorRect = $Vignette
@onready var player : Player = $"../../Player"

func _ready() -> void:
	vignette_color.a = 0.00
	
	if not EventListener.insanity_increased.is_connected(_increase_vignette):
		EventListener.insanity_increased.connect(_increase_vignette)
	
	vignette.material.set_shader_parameter("vignette_color", vignette_color)
	vignette.material.set_shader_parameter("intensity", vignette_intensity)


func _increase_vignette(_sanity_damage: float):
	 # increase vignette alpha based on sanity progression
	vignette_intensity = player.sanity / player.MAX_SANITY
	print(vignette_color)
	vignette.material.set_shader_parameter("vignette_color", vignette_color)
	vignette.material.set_shader_parameter("intensity", vignette_intensity)
