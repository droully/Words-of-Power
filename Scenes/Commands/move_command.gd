extends Command
class_name MoveCommand

var unit
var target_tile
var original_tile
var BF

func _init(_unit, _target_tile, _battlefield):
	self.unit = _unit
	self.target_tile = _target_tile
	self.BF = _battlefield

func execute():
	original_tile = unit.tile_position  # Store the original position before the move
	return BF.place_unit_on_tile(unit, target_tile.x, target_tile.y)

func undo():
	BF.place_unit_on_tile(unit, original_tile.x, original_tile.y)
