extends Area2D

signal heal(value : int)

var is_in_area : bool


func _on_body_entered(body):
	is_in_area = body.name == "mc_witch"
func _on_body_exited(body):
	if body.name == "mc_witch":
		is_in_area = false

func _on_heal_cool_down_timeout():
	$GPUParticles2D2.emitting = true
	if is_in_area:
		heal.emit(2)

