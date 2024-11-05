extends Area2D

var saveresource := SaveResource.new()
var is_in_area : bool


func _on_heal_cool_down_timeout():
	$GPUParticles2D2.emitting = true
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			body.heal.emit(2)
			if body.name == "Witch":
				saveresource.health = body.health
				Saver.save_data(saveresource)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		saveresource.health = body.health
		saveresource.position = position
		Saver.save_data(saveresource)
