extends Node2D

#		VAR
var is_end := false
var is_door := false


#		FUNC
func _input(event):
	if is_door and event.as_text() == "E" and not Transition.is_playing:
		is_end = true
		Transition.play()
		await Transition.finished
		get_tree().change_scene_to_file("res://scenes/House.tscn")


#		SIGNAL
func _on_door_body_entered(body):
	if body.name == "Witch":
		is_door = true
func _on_door_body_exited(body):
	if body.name == "Witch":
		is_door = false

