extends PlayerBaseState
## Player Frozen State

@export var idle_state : PlayerBaseState
@export var dead_state : PlayerBaseState
@export var scared_state : PlayerBaseState

func enter():
	super()
	
	if not EventListener.player_killed.is_connected(_on_player_died):
		EventListener.player_killed.connect(_on_player_died)
	if not EventListener.insanity_increased.is_connected(_on_player_scared):
		EventListener.insanity_increased.connect(_on_player_scared)

# DEBUG
func input(_event: InputEvent) -> BaseState:
	if _event.is_action_pressed("ui_accept"):
		EventListener.insanity_increased.emit(10.0)
		return scared_state
	
	return null


func process(_delta: float) -> BaseState:
	if parent.is_planning:
		return idle_state
	
	return null


func _on_player_died():
	return dead_state


func _on_player_scared(_sanity_damage: float):
	return scared_state
