extends Area2D

var is_in_area : bool


func _on_heal_cool_down_timeout():
	$GPUParticles2D2.emitting = true
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			body.heal.emit(2)

