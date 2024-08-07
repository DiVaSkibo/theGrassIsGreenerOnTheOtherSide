extends CanvasLayer

signal finished


func play():
	$ColorRect.visible = true
	$AnimationPlayer.play("appear")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"appear":
			$AnimationPlayer.play("disappear")
			finished.emit()
		"disappear":
			$ColorRect.visible = false

