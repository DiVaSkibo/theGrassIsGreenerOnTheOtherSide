extends CharacterBody2D

#		CONST
const HEALTH := 6
const POTION = preload("res://scenes/__Potion.tscn")

#		VAR
@export_range(0, 6) var health := 6

@export_range(0, 2000) var speed := 520
@export_range(-2000, 0) var jump_height := -1100
@export_range(0, 2000) var dash_speed := 1100

var gravity = 3 * ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_velocity := Vector2.ZERO


#		FUNC
func _ready():
	for i in health:
		$Health.get_child(i).texture = load("res://just_test_sprites/1hp.png")

func _physics_process(delta):
	# Is dash activated
	if not $DashDuration.is_stopped():
		if $AnimatedSprite2D.flip_h:
			velocity.x = -dash_speed
		else:
			velocity.x = dash_speed
	else:
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
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			# air resistence in up/down
			velocity.y = lerp(prev_velocity.y, velocity.y, 0.8)

		# Attack
		if Input.is_action_pressed("boost") and Input.is_action_pressed("attack") and $AttackCoolDown.is_stopped():
			var potion = POTION.instantiate()
			potion.is_boost = true
			if $AnimatedSprite2D.animation == "run":
				potion.force_x = speed
			potion.force_y = -jump_height + velocity.y
			potion.direction = direction
			potion.global_position.x = global_position.x
			potion.global_position.y = global_position.y - 50
			get_parent().add_child(potion)
			$AttackCoolDown.start()
			$AnimatedSprite2D.play("attack")
		elif Input.is_action_pressed("attack") and $AttackCoolDown.is_stopped():
			var potion = POTION.instantiate()
			potion.is_boost = false
			if $AnimatedSprite2D.animation == "jump":
					potion.force_y = velocity.y / 3
			elif direction:
				potion.force_x = speed
			if $AnimatedSprite2D.flip_h:
				potion.direction = -1
			potion.global_position.x = global_position.x
			potion.global_position.y = global_position.y - 50
			get_parent().add_child(potion)
			$AttackCoolDown.start()
			$AnimatedSprite2D.play("attack")

		# Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_height
		elif Input.is_action_just_released("jump") and velocity.y < 0 or Input.is_action_pressed("attack") and velocity.y < 0:
			velocity.y *= 0.2

		# Animation
		if Input.is_action_just_pressed("dash") and $DashCoolDown.is_stopped() and $AnimatedSprite2D.animation != "attack":
			velocity.x = dash_speed * direction
			velocity.y = 0
			$DashDuration.start()
			$AnimatedSprite2D.play("dash")
		elif is_on_floor() and $AnimatedSprite2D.animation != "attack":
			if direction == 0:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")
		else:
			# air resistence in left/right
			velocity.x = lerp(prev_velocity.x, velocity.x, 0.1)
			if $AnimatedSprite2D.animation != "attack":
				$AnimatedSprite2D.play("jump")

	prev_velocity = velocity
	move_and_slide()

func blink_intensity(value : float):
	$AnimatedSprite2D.material.set_shader_parameter("blink_intensity", value)

func heal(value: int):
	for i in value:
		if health == HEALTH:
			break
		$Health.get_child(health).texture = load("res://just_test_sprites/1hp.png")
		health += 1


#		SIGNAL
func _on_animated_sprite_2d_animation_finished():
	match $AnimatedSprite2D.animation:
		"attack":
			$AnimatedSprite2D.play("idle")

func _on_dash_duration_timeout():
	velocity.x = 0
	$DashCoolDown.start()
func _on_dash_cool_down_timeout():
	if not is_on_floor():
		$DashCoolDown.start()

func _on_hit(value):
	for i in value:
		if not health:
			break
		health -= 1
		$Health.get_child(health).texture = load("res://just_test_sprites/0hp.png")
	var tween = get_tree().create_tween()
	tween.tween_method(blink_intensity, 0.0, 4.0, 0.2)
	tween.tween_method(blink_intensity, 4.0, 0.0, 0.5)
	$GPUParticles2D.restart()
	$GPUParticles2D.emitting = true

