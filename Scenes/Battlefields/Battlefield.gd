extends Node

class_name BattleField

@onready var map:Map = $Map
@onready var units = $Units
@onready var hazards = $Hazards
@onready var deployment_area = map.tiles_in_box(2,4,4,5)
@onready var player = $Units/Player

func _ready():
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))
	
	initialize_units()
	initialize_hazards()
	
func initialize_units():
	for unit in units.get_children():
		unit.initialize(self)
		map.set_unit_on_tile(unit.tile_position,unit)
		
func initialize_hazards():
	for hazard in hazards.get_children():
		hazard.initialize(self)
		map.set_hazard_on_tile(hazard.tile_position,hazard)

func spawn_unit(unit : Unit,tile_position):
	unit.tile_position = tile_position
	units.add_child(unit)
	unit.initialize(self)
	map.set_unit_on_tile(unit.tile_position,unit)
	return true

func get_enemy_units():
	var enemy_units=[]
	for unit in get_children(units):
		if unit.party=="enemy":
			enemy_units.append(unit)
	return enemy_units
	
func place_unit_on_tile(unit: Unit, target_tile:Vector2i):
	#acepta posicion en tile desde el 0	
	
	var unit_in_target_tile=map.get_unit_in_tile(target_tile)
	var path = map.path_between_tiles(unit.tile_position,target_tile)
	if len(path)>0:
		unit.move_through(path)
		unit.tile_position=target_tile
		if unit_in_target_tile:
			unit_in_target_tile.beh.callbackUnitOverlap(unit)
		
		return true
	return false




func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)





	
