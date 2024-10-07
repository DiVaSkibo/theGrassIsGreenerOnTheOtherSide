extends MarginContainer

signal words_finished

const MAX_AMOUNT_OF_WORDS = 10


func say(words : String, coordinate : Vector2):
	$MarginContainer/Label.text = ""
	size = Vector2(0, 0)
	global_position.x = coordinate.x
	global_position.y = coordinate.y - 240
	var k = 0
	for letter in words:
		$LetterDuration.start()
		if letter == ' ':
			if k + 1 == MAX_AMOUNT_OF_WORDS:
				letter = '\n'
				k = 0
			else:
				k += 1
		$MarginContainer/Label.text += letter
		await $LetterDuration.timeout
	$PauseDuration.start()
	await  $PauseDuration.timeout
	words_finished.emit()
