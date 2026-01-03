extends Control

var item: Item = null
@onready var CanvasLayerInstance: CanvasLayer = $CanvasLayer
@onready var Parent: Control = $CanvasLayer/Parent
@onready var label: RichTextLabel = $CanvasLayer/Parent/Description/RichTextLabel
@onready var texture: TextureRect = $CanvasLayer/Parent/Texture/MarginContainer/VBoxContainer/TextureRect

func _ready() -> void:
	CanvasLayerInstance.visible = false

func _physics_process(delta: float) -> void:
	Parent.global_position = lerp(Parent.global_position, get_viewport().get_mouse_position(), delta * 20)	
	
func display_description(should_display: bool) -> void:
	label.get_parent().visible = should_display

func display_texture(should_display: bool) -> void:
	texture.visible = should_display

func display(should_display: bool) -> void:
	CanvasLayerInstance.visible = should_display
