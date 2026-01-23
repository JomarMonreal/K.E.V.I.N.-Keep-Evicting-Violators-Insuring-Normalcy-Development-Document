extends Node

@onready var player : Player = get_owner()


func _ready() -> void:
	EventListener.insanity_increased.connect(_on_insanity_increased)
	EventListener.insanity_reached.connect(_on_insanity_reached)


func damage_sanity(sanity_damage: float):
	player.sanity += sanity_damage
	player.sanity = clamp(player.sanity, 0, player.MAX_SANITY)
	player.scared_flash_modifier = player.sanity / player.MAX_SANITY
	
	if player.sanity >= player.MAX_SANITY:
		EventListener.insanity_reached.emit()


func _on_insanity_increased(damage: float):
	damage_sanity(damage)


func _on_insanity_reached():
	pass
