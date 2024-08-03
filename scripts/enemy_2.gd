extends CharacterBody2D

#		VAR
@export_range(0, 1000) var speed := 180
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#		FUNC
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


#		SIGNAL
func _on_detection_area_body_entered(body):
	pass # Replace with function body.
func _on_detection_area_body_exited(body):
	pass # Replace with function body.

func _on_attack_area_body_entered(body):
	pass # Replace with function body.
func _on_attack_area_body_exited(body):
	pass # Replace with function body.

