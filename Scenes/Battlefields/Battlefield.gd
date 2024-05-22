extends Node

class_name BattleField

@onready var map=$Map
@onready var units= $Units
@onready var deployment_area = map.tiles_in_box(2,4,4,5)


func _ready():
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))
	
	initialize_units()

func initialize_units():
	for unit in units.get_children():
		unit.initialize(self)
		map.set_unit_on_tile(unit.tile_position,unit)

func spawn_unit(unit : Unit,tile_position):
	unit.tile_position = tile_position
	units.add_child(unit)
	unit.initialize(self)
	map.set_unit_on_tile(unit.tile_position,unit)
	return true



func place_unit_on_tile(unit: Unit, tile_position:Vector2i):
	#acepta posicion en tile desde el 0	
	var path = map.path_between_tiles(unit.tile_position,tile_position)
	if len(path)>0:
		unit.move_through(path)
		unit.tile_position=tile_position
		return true
	return false




func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)





	
