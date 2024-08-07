extends MarginContainer

signal words_finished

const MAX_AMOUNT_OF_WORDS = 7


func say(words : String, coordinate : Vector2):
	global_position.x = coordinate.x
	global_position.y = coordinate.y - size.y
	$MarginContainer/Label.text = ""
	var k = 0
	for letter in words:
		if letter == ' ':
			if k + 1 == MAX_AMOUNT_OF_WORDS:
				letter = '\n'
				k = 0
			else:
				k += 1
		$MarginContainer/Label.text += letter
		$Timer.start()
		await $Timer.timeout
	words_finished.emit()

