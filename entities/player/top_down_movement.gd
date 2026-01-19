extends Node

@export var move_speed : float = 700
@export var smooth_start_speed : float = 5
@export var acceleration : float = 2500
@export var friction : float = 3000
@onready var player : Player = get_owner()


func _physics_process(delta: float) -> void:
	if not player.is_planning:
		return # do not move/take input on hiding state
	
	var direction := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	var has_input : bool = direction != Vector2.ZERO
	
	if has_input:
		direction = direction.normalized()
		var target_velocity := direction * move_speed
		var rate = acceleration * delta
		 
		if player.velocity.length() < smooth_start_speed:
			rate *= 0.6
		else:
			rate *= 1
		player.velocity = player.velocity.move_toward(target_velocity, rate)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)
	
	player.move_and_slide()
