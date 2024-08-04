extends CanvasLayer

signal on_transition_finished


func play():
	$ColorRect.visible = true
	$AnimationPlayer.play("appear")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"appear":
			$AnimationPlayer.play("disappear")
			on_transition_finished.emit()
		"disappear":
			$ColorRect.visible = false

