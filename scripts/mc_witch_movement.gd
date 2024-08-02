extends CharacterBody2D

#		CONST
pass

#		VAR
@export_range(0, 1000) var SPEED: int = 150
@export_range(-400, 0) var JUMP_HEIGHT: int = -450
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#		FUNC
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 50

	# Get the input direction and handle the movement/deceleration.
	# direction | left = -1, no_movement = 0, right = 1 | 
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# flip_h sprite
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	# play animation
	if is_on_floor():
		if direction == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	
	move_and_slide()


#		SIGNAL
pass

