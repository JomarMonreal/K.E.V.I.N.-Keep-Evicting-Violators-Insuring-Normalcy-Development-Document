extends PlayerBaseState

@export var hide_state : PlayerBaseState
@export var dead_state : PlayerBaseState


func enter():
	super()
	
	if not EventListener.player_killed.is_connected(_on_player_death):
		EventListener.player_killed.connect(_on_player_death)


func process(_delta: float) -> BaseState:
	# change color by shader or smth showing scared state
	change_color()
	return hide_state


func change_color():
	parent.animations.material.set_shader_parameter("flash_modifier", parent.scared_flash_modifier)
	parent.animations.material.set_shader_parameter("flash_color", parent.scared_flash_color)


func _on_player_death():
	return dead_state
