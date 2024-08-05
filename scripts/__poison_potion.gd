extends RigidBody2D

@export_range(0, 2000) var FORCE_X := 700
@export_range(-2000, 0) var FORCE_Y := -300


func _ready():
	linear_velocity.x = -FORCE_X
	linear_velocity.y = FORCE_Y

func _process(delta):
	$AnimatedSprite2D.rotation += 10 * delta


func _on_area_2d_body_entered(body):
	if not body.name in ["poison_potion", "mc_witch"]:
		print(body, '\n')
		queue_free()

