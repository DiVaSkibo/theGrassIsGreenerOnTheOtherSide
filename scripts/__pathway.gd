extends Area2D

signal switch_scene(scene : String)

@export var scene : String
var is_entered : bool = false


func _input(event):
	if is_entered and event.as_text() == "E" and not Transition.is_playing:
		switch_scene.emit(scene)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		is_entered = true
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Witch":
		is_entered = false
