extends CharacterBody2D

#		VAR
@export_range(0, 1000) var speed := 180
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var victim = null
var is_victim_in_attack_area := false


#		FUNC
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if $AnimatedSprite2D.animation == "attack":
		pass
	elif victim:
		position += (victim.position - position) / speed
		$AnimatedSprite2D.play("move")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimatedSprite2D.play("idle")

	#velocity.x = direction * speed
	#velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


#		SIGNAL
func _on_detection_area_body_entered(body):
	if body.name == "mc_witch":
		victim = body
func _on_detection_area_body_exited(body):
	if body.name == "mc_witch":
		victim = null

func _on_attack_area_body_entered(body):
	if body == victim:
		is_victim_in_attack_area = true
		$AnimatedSprite2D.play("attack")
func _on_attack_area_body_exited(body):
	if body == victim:
		is_victim_in_attack_area = false

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack" and is_victim_in_attack_area:
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("idle")

