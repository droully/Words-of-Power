extends VBoxContainer

func _ready():
	for button in get_children():
		button.pressed.connect(_on_button_pressed.bind(button))
		
func _on_button_pressed(button):
	var battlescene :BattleScene =  Utils.switch_level("res://Scenes/BattleScenes/battlescene/battlescene.tscn")
	
	var level_number=button.name.right(1)
	
	
	var level= Utils.get_level_by_number(level_number)
	battlescene.initialize(level)
	
