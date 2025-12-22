extends PlayerBaseState

const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func physics_process(delta):
	var player := entity as Player
		
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = JUMP_FORCE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)

	player.move_and_slide()
	
	if player.velocity.x == 0 and player.velocity.y == 0:
		return PlayerBaseState.State.Idle
	
	return PlayerBaseState.State.Moving
