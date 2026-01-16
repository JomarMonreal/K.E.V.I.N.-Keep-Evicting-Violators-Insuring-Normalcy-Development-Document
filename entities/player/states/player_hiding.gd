extends PlayerBaseState
## Player Frozen State

@export var idle_state : PlayerBaseState
@export var dead_state : PlayerBaseState


func enter():
	super()
	
	if not EventListener.player_killed.is_connected(_on_player_died):
		EventListener.player_killed.connect(_on_player_died)


func process(_delta: float) -> BaseState:
	if parent.is_planning:
		return idle_state
	
	return null


func _on_player_died():
	return dead_state
