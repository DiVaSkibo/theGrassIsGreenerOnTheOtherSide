extends CharacterBody2D

#		VAR
@export_range(0, 2000) var speed := 700
@export_range(-2000, 0) var jump_height := -1200
@export_range(0, 2000) var dash_speed := 1200
var gravity = 3 * ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_velocity := Vector2.ZERO

const POISON_POTION = preload("res://scenes/__PoisonPotion.tscn")


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
			# air resistence in up_down
			velocity.y = lerp(prev_velocity.y, velocity.y, 0.8)

		# Attack
		if Input.is_action_just_pressed("attack"):
			var pp = POISON_POTION.instantiate()
			get_parent().add_child(pp)
			pp.position.x = position.x
			pp.position.y = position.y - 50

		# Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_height
		elif Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.2

		# Direction and Movement/Deceleration
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true

		# Animation
		if Input.is_action_just_pressed("dash") and $DashDuration.is_stopped() and $DashCoolDown.is_stopped():
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
func _on_dash_duration_timeout(): # dash end
	velocity.x = 0
	$DashCoolDown.start()
func _on_dash_cool_down_timeout(): # dash cool down end if mc is on the floor
	if not is_on_floor():
		$DashCoolDown.start()

