extends Node2D

func _on_level_1_pressed():	
	var battlescene :BattleScene =  Utils.switch_level("res://Scenes/BattleScenes/battlescene/battlescene.tscn")
	var level= Utils.get_level_by_number(1)
	battlescene.initialize(level)


func _on_level_2_pressed():
	Utils.switch_level("res://Scenes/Battlefields/Level2/level_2.tscn")
