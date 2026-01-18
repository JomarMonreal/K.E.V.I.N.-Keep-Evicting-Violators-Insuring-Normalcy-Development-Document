extends PlayerBaseState

@export var hide_state : PlayerBaseState
@export var dead_state : PlayerBaseState

@export var flash_timer : Timer


func enter():
	# not entering
	super()
	print("scared!")
	
	if not EventListener.player_killed.is_connected(_on_player_death):
		EventListener.player_killed.connect(_on_player_death)


func process(_delta: float) -> BaseState:
	
	# change color by shader or smth showing scared state
	flash()
	return hide_state


func flash():
	parent.animations.material.set_shader_parameter("flash_modifier", parent.scared_flash_modifier)
	parent.animations.material.set_shader_parameter("flash_color", parent.scared_flash_color)
	flash_timer.start()


func _on_player_death():
	return dead_state


func _on_flash_timer_timeout() -> void:
	parent.animations.material.set_shader_parameter("flash_modifier", 0.0)
