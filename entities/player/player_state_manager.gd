class_name PlayerStateManager
extends BaseStateManager

@export var starting_state : BaseState


func init(parent: Player):
	for child in get_children():
		child.parent = parent
	
	initial_state = starting_state
	change_state(initial_state)
