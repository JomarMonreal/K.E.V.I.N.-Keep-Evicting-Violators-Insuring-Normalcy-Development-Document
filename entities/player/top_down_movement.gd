extends Node

@export var move_speed : float = 300
@export var acceleration : float = 5
@export var friction : float = 8
@onready var player : Player = get_owner()


func _physics_process(delta: float) -> void:
	if not player.is_planning:
		return # do not move/take input on hiding state
	
	var direction := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	var lerp_weight = delta * (acceleration if direction else friction)
	player.velocity = lerp(player.velocity, direction.normalized() * move_speed, lerp_weight)
	player.move_and_slide()
