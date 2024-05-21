extends Node
	
func execute_turn(_BM, BF):
	var unit = get_parent()
	var unit_tile = unit.tile_position  
	
	
	var front_tile=unit_tile+Utils.dir2vector[unit.get_orientation()]
	var back_tile=unit_tile-Utils.dir2vector[unit.get_orientation()]
	var target_tile=null
	
	if front_tile in unit.walkable_tiles():
		target_tile=front_tile
	elif back_tile in unit.walkable_tiles():
		target_tile=back_tile
		unit.reverse_orientation()
	else:
		target_tile= unit_tile
		unit.reverse_orientation()
	var moveCommand = Command.Move.new(unit, target_tile, BF)
	return moveCommand
	
