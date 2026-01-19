extends Node

@onready var player : Player = get_owner()

const MAX_SANITY : float = 100.0
@onready var sanity : float = 0


func _ready() -> void:
	EventListener.insanity_increased.connect(_on_insanity_increased)
	EventListener.insanity_reached.connect(_on_insanity_reached)


func damage_sanity(sanity_damage: float):
	sanity += sanity_damage
	sanity = clamp(sanity, 0, MAX_SANITY)
	player.scared_flash_modifier = sanity / MAX_SANITY
	
	if sanity >= MAX_SANITY:
		EventListener.insanity_reached.emit()


func _on_insanity_increased(damage: float):
	damage_sanity(damage)


func _on_insanity_reached():
	pass
