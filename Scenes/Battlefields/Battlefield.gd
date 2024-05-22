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
		set_unit(unit)

func spawn_unit(unit : Unit,tile_position):
	unit.tile_position = tile_position
	units.add_child(unit)
	unit.initialize(self)
	map.get_cell_in_tile(unit.tile_position).set_custom_data("UnitTracking",unit)
	return true

func set_unit(unit : Unit):
	unit.initialize(self)
	map.get_cell_in_tile(unit.tile_position).set_custom_data("UnitTracking",unit)

func place_unit_on_tile(unit: Unit, tile_position_x:int, tile_position_y:int):
	#acepta posicion en tile desde el 0	
	var tile_position=Vector2i(tile_position_x,tile_position_y)
	var path = map.grid.get_id_path(unit.tile_position,tile_position)
	if len(path)>0:
		unit.move_through(path)
		unit.tile_position=tile_position
		return true
	return false



func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)


	
