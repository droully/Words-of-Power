extends Node

func choose_command(BF):
	var unit= get_parent() 
	var unit_tile = unit.tile_position  
	
	
	var front_tile=unit_tile+Utils.dir2vector[unit.get_orientation()]
	var back_tile=unit_tile-Utils.dir2vector[unit.get_orientation()]
	var target_tile=null
	
	if not BF.map.is_tile_solid(front_tile):
		target_tile=front_tile
	elif not BF.map.is_tile_solid(back_tile):
		target_tile=back_tile
		unit.rotate_orientation(180)
	else:
		target_tile= unit_tile
		unit.rotate_orientation(180)
	var moveCommand = Command.Move.new(unit, target_tile, BF)
	return moveCommand
	
func callbackUnitOverlap(unit_on_top):
	var unit = get_parent() 
	unit_on_top.die()
	unit.die()
