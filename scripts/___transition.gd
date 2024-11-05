extends CanvasLayer

signal finished

var is_playing := false


func play():
	is_playing = true
	$ColorRect.visible = true
	$AnimationPlayer.play("appear")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"appear":
			$AnimationPlayer.play("disappear")
			finished.emit()
		"disappear":
			is_playing = false
			$ColorRect.visible = false
