extends RigidBody2D

#		VAR
@export_range(0, 2000) var force_x := 700
@export_range(-2000, 0) var force_y := -300
@export_range(0, 2000) var speed_x := 0
@export_range(-2000, 0) var speed_y := 0
@export_range(-1, 1) var direction := 1


#		FUNC
func _ready():
	linear_velocity.x = direction * (force_x + speed_x)
	linear_velocity.y = force_y + speed_y

func _process(delta):
	$AnimatedSprite2D.rotation += 10 * delta


#		SIGNAL
func _on_area_2d_body_entered(body):
	if body.name.begins_with("enemy") or body.name.begins_with("floor"):
		queue_free()

