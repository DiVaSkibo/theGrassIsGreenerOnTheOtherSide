extends Node2D

#		VAR
var is_end := false


#		FUNC
pass


#		SIGNAL
func _end(scene: String) -> void:
		is_end = true
		Transition.play()
		await Transition.finished
		get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn")
