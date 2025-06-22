extends Node

class_name BattleField

@onready var map : CustomTileMapLayer = $Map
@onready var walls = $Walls
@onready var bg = $Background
@onready var highlight = $Highlight
@onready var units = $Units
@onready var grounds = $Grounds
@onready var hazards = $Hazards
@onready var player

var size_x = 30
var size_y = 30
var hazard_tracker ={}

func _ready():
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))
	Events.player_created.connect(_on_player_created)


func place_unit_on_tile(unit: Unit, target_tile:Vector2i):
	#acepta posicion en tile desde el 0	
	
	var unit_in_target_tile = units.get_on_tile(target_tile)
	var path = [map.tile_to_position(unit.tile_position),map.tile_to_position(target_tile)]
	if unit_in_target_tile:
		return false #por mientras todo colisiona
	if unit_in_target_tile==unit:
		print("unit_in_target_tile = unit")
	

	if len(path)>0:	
		unit.move_through(path)
		if unit.beh.has_method("callbackMovementFrom"):
			unit.beh.callbackMovementFrom(self)
		units.set_on_tile(unit,target_tile)
		if unit_in_target_tile and unit_in_target_tile!=unit:
			return collide_units(unit,unit_in_target_tile)
			
		return true
	return false
	
func collide_units(_unit1:Unit,_unit2:Unit):
	#var _result1=unit1.beh.callbackUnitOverlap(unit2)
	#var _result2=unit2.beh.callbackUnitOverlap(unit1)aaaaa
	return false


func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)

func set_hazard_on_tile(hazard :Hazard,tile_position:Vector2i):
	hazard_tracker.erase(hazard.tile_position)
	hazard_tracker[tile_position] = hazard

func get_hazard_on_tile(tile_position:Vector2i):
	return hazard_tracker.get(tile_position)

func _on_player_created(_player):
	player=_player
