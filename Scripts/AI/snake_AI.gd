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
		unit.rotate_orientation(180)
	else:
		target_tile= unit_tile
		unit.rotate_orientation(180)
	var moveCommand = Command.Move.new(unit, target_tile, BF)
	return moveCommand
	
