extends Node

@export var max_sanity : float = 100
@export var sanity_increment : float = 10
var sanity : float = 0


func _ready() -> void:
	EventListener.insanity_increased.connect(_on_insanity_increased)
	EventListener.insanity_reached.connect(_on_insanity_reached)


func _on_insanity_increased():
	sanity += sanity_increment
	sanity = max(sanity, max_sanity)
	
	if sanity >= max_sanity:
		EventListener.insanity_reached.emit()


func _on_insanity_reached():
	pass
