extends Node2D

var word: String
@onready var label = $WordLabel
var total_att : int  = 0
var total_def : int  = 0

signal word_calculated(total_att, total_def)

func _on_word_text_text_submitted(new_text):
	word = new_text.to_lower()
	label.text = word
	
	total_att=0
	total_def=0
	var LS = $LetterStats.letter_stats
	
	for letter in word:
		total_att = total_att+LS[letter]["attack"]
		total_def = total_def+LS[letter]["defense"]
	emit_signal("word_calculated", total_att, total_def)

func create_dict():
	
	var dict = []
	var file = FileAccess.open("res://Resources/palabras.txt", FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		dict.append(line.split(","))
	file.close()

	return dict




