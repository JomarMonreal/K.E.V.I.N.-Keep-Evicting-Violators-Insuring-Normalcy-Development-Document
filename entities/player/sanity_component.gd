extends Node

@export var max_sanity : float = 100
var sanity : float = 0


func _ready() -> void:
	EventListener.insanity_increased.connect(_on_insanity_increased)
	EventListener.insanity_reached.connect(_on_insanity_reached)


func damage_sanity(sanity_damage: float):
	sanity += sanity_damage
	sanity = max(sanity, max_sanity)
	
	if sanity >= max_sanity:
		EventListener.insanity_reached.emit()


func _on_insanity_increased(damage: float):
	damage_sanity(damage)


func _on_insanity_reached():
	pass
