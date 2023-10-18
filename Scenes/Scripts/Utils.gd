extends Node

func get_spell_by_name(spell_name: String):
	var basespell_rsc = load("res://Scenes/Spells/"+spell_name+".tscn").instantiate()
	var spell = basespell_rsc.duplicate()
	return spell

func array_unique(array: Array) -> Array:
	var unique: Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)

	return unique
