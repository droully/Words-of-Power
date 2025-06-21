extends Node

var spell_names = []
var spell_data ={}
var spell_inputs = {}


func _ready():
	var dir =  DirAccess.open("res://Scenes/Spells/")
	if dir:
		dir.list_dir_begin()
		var spell_name = dir.get_next()
		while spell_name != "":
			if dir.current_is_dir():
				var spell_res=Utils.get_spell_data_by_name(spell_name)
				if spell_res.player_usable==true:

					spell_names.append(spell_name)
					spell_inputs[spell_res.spell_input]=spell_name
					spell_data[spell_name]=spell_res
			spell_name = dir.get_next()
			
func get_spell_data_from_input(spell_input):
	return spell_data.get(spell_inputs.get(spell_input))
