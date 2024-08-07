extends Area2D

signal hit(value : int)

@export_range(0, 2000) var force := 300
var is_boost : bool


func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if body is CharacterBody2D and not is_boost:
			pass
		elif body is CharacterBody2D:
			body.velocity = 3 * force * (body.global_position - global_position).normalized()
		elif body is RigidBody2D:
			body.apply_central_impulse((body.global_position - global_position).normalized() * force)


func _on_timer_timeout():
	queue_free()

