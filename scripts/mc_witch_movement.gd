extends CharacterBody2D

#		VAR
@export_range(0, 1000) var SPEED: int = 180
@export_range(-400, 0) var JUMP_HEIGHT: int = -380
@export_range(0, 1000) var DASH_SPEED: int = 350
@export_range(0.0, 2.0) var DASH_DURATION: float = 0.3
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prevVelocity: Vector2 = Vector2.ZERO

# Dash variables
@onready var dash_cool_down = $DashCoolDown
var can_dash = true
var is_dashing = false
var dash_timer = 0.0
var facing_direction = 1 # 1 - right, -1 - left

#		FUNC
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = lerp(prevVelocity.y, velocity.y, 0.8) # air resistence in up_down

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			end_dash()
	else:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_HEIGHT
		elif Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.2

		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			facing_direction = direction # direction for dash
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Handle dash
		if Input.is_action_just_pressed("dash") and can_dash and is_on_floor():
			start_dash(facing_direction)

		# flip_h sprite
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true

		# play animation
		if is_on_floor() and not is_dashing:
			if direction == 0:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")
		elif not is_on_floor() and not is_dashing:
			velocity.x = lerp(prevVelocity.x, velocity.x, 0.1) # air resistence in left_right
			$AnimatedSprite2D.play("jump")

	prevVelocity = velocity
	move_and_slide()

# Start the dash
func start_dash(direction):
	is_dashing = true
	dash_timer = DASH_DURATION
	can_dash = false
	velocity.x = DASH_SPEED * direction

	# Start dash animation only once
	if $AnimatedSprite2D.animation != "dash":
		$AnimatedSprite2D.play("dash")

	dash_cool_down.start(0.6) # Adjust cooldown time

# End the dash
func end_dash():
	is_dashing = false
	velocity.x = 0

#		SIGNAL
func _on_dash_cool_down_timeout():
	can_dash = true
