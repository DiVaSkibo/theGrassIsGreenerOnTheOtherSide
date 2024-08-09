extends Area2D

const TEXT_BOX = preload("res://scenes/___TextBox.tscn")
@export var dialog : Array[String]
var is_active := false


func _on_body_entered(body):
	if not is_active and body.name == "Witch":
		is_active = true
		var textbox = TEXT_BOX.instantiate()
		get_parent().find_child("Witch").add_child(textbox)
		for words in dialog:
			textbox.say(words, body.global_position)
			await textbox.words_finished
		textbox.queue_free()
		queue_free()

