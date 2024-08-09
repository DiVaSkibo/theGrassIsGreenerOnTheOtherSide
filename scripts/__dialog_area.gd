extends Area2D

const TEXT_BOX = preload("res://scenes/___TextBox.tscn")
@export var dialog : Array[String]


func _on_body_entered(body):
	if body.name == "Witch":
		var textbox = TEXT_BOX.instantiate()
		add_child(textbox)
		for words in dialog:
			textbox.say(words, body.global_position)
			await textbox.words_finished
		textbox.queue_free()

