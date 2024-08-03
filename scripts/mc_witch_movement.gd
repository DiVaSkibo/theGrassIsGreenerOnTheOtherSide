extends CharacterBody2D

#		VAR
@export_range(0, 1000) var speed := 180
@export_range(-400, 0) var jump_height := -380
@export_range(0, 1000) var dash_speed := 350
@export_range(0.0, 2.0) var dash_duration := 0.3
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_velocity := Vector2.ZERO


#		FUNC
func _physics_process(delta):
	# is dash activated
	if not $DashDuration.is_stopped():
		if $AnimatedSprite2D.flip_h:
			velocity.x = -dash_speed
		else:
			velocity.x = dash_speed
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			velocity.y = lerp(prev_velocity.y, velocity.y, 0.8) # air resistence in up_down

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_height
		elif Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.2

		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		# flip_h sprite
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true

		# Play animation
		if Input.is_action_just_pressed("dash") and $DashDuration.is_stopped() and $DashCoolDown.is_stopped():
			# start dash
			velocity.x = dash_speed * direction
			velocity.y = 0
			$DashDuration.start()
			$AnimatedSprite2D.play("dash")
		elif is_on_floor():
			if direction == 0:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")
		else:
			velocity.x = lerp(prev_velocity.x, velocity.x, 0.1) # air resistence in left_right
			$AnimatedSprite2D.play("jump")

	prev_velocity = velocity
	move_and_slide()


#		SIGNAL
# dash end
func _on_dash_duration_timeout():
	velocity.x = 0
	$DashCoolDown.start()
# dash cool down end if mc is on the floor
func _on_dash_cool_down_timeout():
	if not is_on_floor():
		$DashCoolDown.start()

