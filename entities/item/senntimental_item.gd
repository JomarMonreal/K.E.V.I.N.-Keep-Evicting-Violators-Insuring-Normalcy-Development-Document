extends Area2D
class_name SentimentalItem


func _on_body_entered(body: Node2D) -> void:
	if body is Invader:
		body.states.change_state(InvaderBaseState.State.Stealing)
		queue_free()
