extends Node2D


func _on_area_2d_body_entered(body):
	if body.name == "Witch":
		Transition.play()
		await Transition.finished
		get_tree().change_scene_to_file("res://scenes/Forest.tscn")

