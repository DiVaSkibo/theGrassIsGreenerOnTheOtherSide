extends CharacterBody2D

signal hit(value : int)
signal heal(value : int)

#		CONST
const HEALTH := 3

#		VAR
@export_range(0, 6) var health := HEALTH

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
		if is_on_floor() and not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.1, 0.3)
			$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.play("move")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimatedSprite2D.play("idle")

	#velocity.x = direction * speed
	#velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func blink_intensity(value : float):
	$AnimatedSprite2D.material.set_shader_parameter("blink_intensity", value)


#		SIGNAL
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack" and is_victim_in_attack_area:
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	if body.name == "Witch":
		victim = body
func _on_detection_area_body_exited(body):
	if body.name == "Witch":
		victim = null

func _on_attack_area_body_entered(body):
	if body == victim:
		is_victim_in_attack_area = true
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		if is_victim_in_attack_area:
			body.hit.emit(1)

func _on_attack_area_body_exited(body):
	if body == victim:
		is_victim_in_attack_area = false

func _on_hit(value):
	health -= value
	$AnimatedSprite2D.material.set_shader_parameter("blink_color", Color("d83000"))
	var tween = get_tree().create_tween()
	tween.tween_method(blink_intensity, 0.0, 4.0, 0.2)
	tween.tween_method(blink_intensity, 4.0, 0.0, 0.5)
	if health <= 0:
		queue_free()
func _on_heal(value):
	if health != HEALTH:
		health += value
		$AnimatedSprite2D.material.set_shader_parameter("blink_color", Color("7fce63de"))
		var tween = get_tree().create_tween()
		tween.tween_method(blink_intensity, 0.0, 4.0, 0.2)
		tween.tween_method(blink_intensity, 4.0, 0.0, 0.5)

