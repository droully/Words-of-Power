extends Control

var letters = []
@export var letter_stats = {}

func _ready():
	
	var file = FileAccess.get_file_as_string("res://Resources/LetterStats.json")	
	letter_stats = JSON.parse_string(file)


