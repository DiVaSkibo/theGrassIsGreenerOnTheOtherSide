extends MarginContainer

signal on_text_box_words_finished

const MAX_WIDTH = 20


func _ready():
	say("Pool rush on 12 miners!")

func say(words : String):
	$MarginContainer/Label.text = ""
	for letter in words:
		$MarginContainer/Label.text += letter
		$Timer.start()
		await $Timer.timeout

