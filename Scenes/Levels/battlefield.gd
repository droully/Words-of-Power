extends Node

class_name BattleField

@onready var map : BaseMapLayer = $Map
@onready var bg = $Background
@onready var walls :WallsMapLayer = $Walls
@onready var highlight : HighlightMapLayer= $Highlight
@onready var grounds : GroundsMapLayer = $Grounds
@onready var hazards : HazardMapLayer = $Hazards
@onready var units : UnitsMapLayer= $Units

@export var level_number:int

var player:Unit
var previous_player_position
var size_x = 30
var size_y = 30

var win=false

func _ready():
	Events.player_created.connect(_on_player_created)
	Events.command_unit_moved.connect(_on_command_unit_moved)
	Events.win_level.connect(_on_win_level)
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))

func is_tile_solid(tile:Vector2i):
	var ground = grounds.get_on_tile(tile)
	if ground:
		return  ground.solid
	return false

func is_tile_walkable(tile:Vector2i):
	var wall = walls.is_tile_solid(tile)
	var ground = grounds.get_on_tile(tile)
	var walkable_ground=false
	if ground:
		walkable_ground = ground.walkable
	var unit = units.get_on_tile(tile)
	#ground = true
	return walkable_ground and not wall and not unit

func collide_units(_unit1:Unit,_unit2:Unit):
	#var _result1=unit1.beh.callbackUnitOverlap(unit2)
	#var _result2=unit2.beh.callbackUnitOverlap(unit1)aaaaa
	return false

func push(tile:Vector2i, dir:Vector2i):
	var unit = units.get_on_tile(tile)
	var ground = grounds.get_on_tile(tile)

	var target_tile = tile + dir  # chequear colisiones
	var target_unit =  units.get_on_tile(target_tile)
	var target_ground = grounds.get_on_tile(target_tile)

	if walls.is_tile_solid(target_tile):
		return false

	if target_unit or target_ground:
		return false

	if unit:
		units.place_on_tile(unit, target_tile)
	if ground:
		if ground.pushable:
			grounds.place_on_tile(ground, target_tile)
	return true

func pull(tile:Vector2i,dir:Vector2i):	
	return push(tile,-dir)
	
func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)



func _on_win_level():
	win=true

func _on_command_unit_moved(unit, from_tile,_to_tile):
	if unit==player:
		previous_player_position=from_tile

func _on_player_created(_player):
	player=_player
