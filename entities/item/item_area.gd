class_name ItemArea
extends Area2D

@export var item_info: Item
@onready var sprite: Sprite2D = $Texture

func _process(delta: float) -> void:
	if sprite.texture != item_info.texture:
		sprite.texture = item_info.texture
	
