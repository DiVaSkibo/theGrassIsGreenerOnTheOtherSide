extends CharacterBody2D

signal hit(value : int)
signal heal(value : int)

#		CONST
const HEALTH := 2

#		VAR
@export_range(0, 6) var health := HEALTH

@export_range(0, 1000) var speed := 180
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := 1


#		FUNC
func _physics_process(delta):
	if $RightRayCast.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	if $LeftRayCast.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
	position.x += direction * speed * delta

func blink_intensity(value : float):
	$AnimatedSprite2D.material.set_shader_parameter("blink_intensity", value)


#		SIGNAL
func _on_area_2d_body_entered(body):
	if body.name == "Witch":
		body.hit.emit(2)

func _on_hit(value):
	health -= value
	$AnimatedSprite2D.material.set_shader_parameter("blink_color", Color("003e2e"))
	var tween = get_tree().create_tween()
	tween.tween_method(blink_intensity, 0.0, 4.0, 0.2)
	tween.tween_method(blink_intensity, 4.0, 0.0, 0.5)
	if health <= 0:
		queue_free()
func _on_heal(value):
	health += value
	$AnimatedSprite2D.material.set_shader_parameter("blink_color", Color("7fce63de"))
	var tween = get_tree().create_tween()
	tween.tween_method(blink_intensity, 0.0, 4.0, 0.2)
	tween.tween_method(blink_intensity, 4.0, 0.0, 0.5)

