extends Node


var current_scene = null

var dir2vector = {"UP":Vector2i.UP,"RIGHT":Vector2i.RIGHT,"DOWN":Vector2i.DOWN,"LEFT":Vector2i.LEFT}
enum Orientations { UP, RIGHT, DOWN, LEFT }



var move_inputs=["move_left", "move_right", "move_up", "move_down"]
var spell_inputs=["spell_1","spell_2","spell_3"]
var player

func _ready():
	var root = get_tree().root
	current_scene=root.get_child(root.get_child_count()-1)
	pass

func rotate_dir(dir:Vector2i,steps: int):
	var effective_steps = steps % 4
	if effective_steps < 0:
		effective_steps += 4
	var rotated_dir = dir
	for _i in range(effective_steps):
		rotated_dir = Vector2i(rotated_dir.y, -rotated_dir.x)
	return rotated_dir
	
	
	

func compare_elements(ele1:String,ele2:String):
	var elem_dict={"water": {"weakTo": 'earth', "strongTo": 'fire'},
	"fire": {"weakTo": 'water', "strongTo": 'earth'},
	"earth": {"weakTo": 'fire', "strongTo": 'water'}}

	if elem_dict[ele1]["weakTo"]==ele2:
		return ele2
	if elem_dict[ele1]["strongTo"]==ele2:
		return ele1

func _defferred_switch_scene(res_path):
	current_scene.free()
	var s=load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene=current_scene
	return current_scene
	
func switch_scene(res_path):
	call_deferred("_defferred_switch_scene",res_path)
	
func switch_level(level_path):
	if current_scene:
		current_scene.queue_free()
#	get_tree().process_frame  # wait 1 frame if necessary
	var s = load(level_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	return current_scene
	
func priority_compare(a:Unit, b:Unit):
	return a.priority < b.priority

func get_spell_by_name(spell_name: String):
	var spell = load("res://Scenes/Spells/"+spell_name+"/"+spell_name+".tscn").instantiate()
	return spell

func get_spell_data_by_name(spell_name: String):
	var spell_data = load("res://Scenes/Spells/"+spell_name+"/"+spell_name+".tres")
	return spell_data

func get_unit_by_name(unit_name: String):
	var unit = load("res://Scenes/units/"+unit_name+"/"+unit_name+".tscn").instantiate()
	return unit

func get_hazard_by_name(hazard_name: String):
	var hazard = load("res://Scenes/hazards/"+hazard_name+"/"+hazard_name+".tscn").instantiate()
	return hazard

func get_unit_data_by_name(unit_name: String):
	var unit_data = load("res://Scenes/units/"+unit_name+"/"+unit_name+".tres")
	return unit_data

func get_level_by_number(number):
	var level = load("res://Scenes/Battlefields/Level"+str(number)+"/Level"+str(number)+".tscn").instantiate()
	return level

func get_battlefield_by_name(battlefield_name: String):
	var BF = load("res://Scenes/Battlefields/"+battlefield_name+"/"+battlefield_name+".tscn").instantiate()
	return BF

func array_unique(array: Array) -> Array:
	var unique: Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)

	return unique
