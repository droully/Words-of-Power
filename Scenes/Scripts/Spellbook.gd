extends Node

var spell_names =[]
var spell_names_UI=[]
var spell_data =[]


func _ready():
	var dir =  DirAccess.open("res://Scenes/Spells/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var spell_res=Utils.get_spell_data_by_name(file_name)
				if spell_res.player_usable==true:

					spell_data.append(spell_res)
					spell_names_UI.append(spell_res.spell_name_UI)
					spell_names.append(file_name)
				
			file_name = dir.get_next()
			



