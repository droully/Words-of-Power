extends Node

class_name BattleField

@onready var map = $Map
@onready var walls = $Walls
@onready var bg = $Background
@onready var highlight = $Highlight
@onready var units = $Units
@onready var hazards = $Hazards
@onready var player

var size_x
var size_y
var unit_tracker ={}
var hazard_tracker ={}

func _ready():
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))
	Events.player_created.connect(_on_player_created)
	Events.debug.connect(_on_debug)
	setup(30,30)

func setup(x,y):

	size_x=x
	size_y=y
	


func place_unit_on_tile(unit: Unit, target_tile:Vector2i):
	#acepta posicion en tile desde el 0	
	
	var unit_in_target_tile = get_unit_on_tile(target_tile)
	var path = [map.tile_to_position(unit.tile_position),map.tile_to_position(target_tile)]

	if len(path)>0:	
		unit.move_through(path)
		if unit.beh.has_method("callbackMovementFrom"):
			unit.beh.callbackMovementFrom(self)
		set_unit_on_tile(unit,target_tile)
		if unit_in_target_tile and unit_in_target_tile!=unit:
			collide_units(unit,unit_in_target_tile)


		return true
	return false
	
func collide_units(unit1:Unit,unit2:Unit):
	var result1=unit1.beh.callbackUnitOverlap(unit2)
	var result2=unit2.beh.callbackUnitOverlap(unit1)
	#colisionar con info de units o no? 


func _on_debug():
	hazards.spawn_hazard(Utils.get_hazard_by_name("fire_hazard"),Vector2i(2,2))
	

func is_tile_solid(tile):
	var a =  walls.get_cell_tile_data(tile)
	return a


func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)

func get_unit_on_tile(tile_position:Vector2i):
	return unit_tracker.get(tile_position)
	#return map.get_cell_tile_data(tile_position).get_custom_data("Units")
	
func set_unit_on_tile(unit:Unit,target_tile:Vector2i):

	unit_tracker.erase(unit.tile_position)
	unit_tracker[target_tile] = unit
	unit.tile_position=target_tile
	#map.get_cell_tile_data(tile_position).set_custom_data("Units",unit)

func get_hazard_on_tile(tile_position:Vector2i):
	return hazard_tracker.get(tile_position)
	
func set_hazard_on_tile(hazard :Hazard,tile_position:Vector2i):
	hazard_tracker.erase(hazard.tile_position)
	hazard_tracker[tile_position] = hazard

func _on_player_created(unit):
	player=unit
