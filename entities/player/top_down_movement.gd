extends Node

@export_group("Movement Parameters")
@export var move_speed : float = 700
@export var smooth_start_speed : float = 10
@export var acceleration : float = 500
@export var friction : float = 3000

@onready var player : Player = get_owner()


func _physics_process(delta: float) -> void:
	if not player.is_planning:
		return # do not move/take input on hiding state
	
	var direction := Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	
	var has_input : bool = direction != Vector2.ZERO
	
	if has_input:
		direction = direction.normalized()
		var target_velocity := direction * move_speed
		player.velocity = target_velocity
		var rate = acceleration * delta
		
		if player.velocity.length() < smooth_start_speed:
			rate *= 0.6
		else:
			rate *= 1
		player.velocity = player.velocity.move_toward(target_velocity, rate)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)
	
	player.move_and_slide()
