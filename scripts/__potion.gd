extends RigidBody2D

#		CONST
const EFFECT = preload("res://scenes/__Effect.tscn")

#		VAR
@export_range(0, 2000) var force_x := 0
@export_range(-2000, 0) var force_y := 0
@export_range(0, 2000) var speed_x := 700
@export_range(-2000, 0) var speed_y := -300
@export_range(-1, 1) var direction := 1

var is_boost : bool


#		FUNC
func _ready():
	if is_boost:
		$AnimatedSprite2D.play("boost")
	linear_velocity.x = direction * (force_x + speed_x)
	linear_velocity.y = force_y + speed_y

func _process(delta):
	$AnimatedSprite2D.rotation += 10 * delta


#		SIGNAL
func _on_area_2d_body_entered(body):
	if body.name.begins_with("enemy") or body.name.begins_with("floor"):
		var effect = EFFECT.instantiate()
		effect.is_boost = is_boost
		effect.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", effect)
		queue_free()

