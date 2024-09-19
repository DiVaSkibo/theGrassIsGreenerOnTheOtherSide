extends Area2D

@export_range(0, 2000) var force := 300
var is_boost : bool


func _ready():
	if is_boost:
		$PoisonCollision.disabled = true
		$AnimatedSprite2D.play("boost")
	else:
		$BoostCollision.disabled = true

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if not is_boost:
			pass
		elif body is CharacterBody2D:
			body.velocity = 3 * force * (body.global_position - global_position).normalized()
		elif body is RigidBody2D:
			body.apply_central_impulse(force * (body.global_position - global_position).normalized())


func _on_body_entered(body):
	if is_boost and body.name == "Witch":
		body.has_dash_access = true
	elif not is_boost and body is CharacterBody2D:
		body.hit.emit(1)

func _on_timer_timeout():
	queue_free()
