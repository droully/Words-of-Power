extends Node


var current_scene = null
func _ready():
	var root = get_tree().root
	current_scene=root.get_child(root.get_child_count()-1)
	
func switch_scene(res_path):
	call_deferred("_defferred_switch_scene",res_path)
	
func _defferred_switch_scene(res_path):
	current_scene.free()
	var s=load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene=current_scene

func priority_compare(a:Unit, b:Unit):
	return a.priority < b.priority

func get_spell_by_name(spell_name: String):
	var spell = load("res://Scenes/Spells/"+spell_name+".tscn").instantiate()
	return spell

func get_unit_by_name(unit_name: String):
	var unit = load("res://Scenes/units/"+unit_name+".tscn").instantiate()
	return unit

func array_unique(array: Array) -> Array:
	var unique: Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)

	return unique
