extends CustomTileMapLayer





var unit_tracker = {}

func get_on_tile(tile_position:Vector2i):
	return unit_tracker.get(tile_position)
	#return map.get_cell_tile_data(tile_position).get_custom_data("Units")

func set_on_tile(unit:Unit,to_tile:Vector2i):
	var from_tile=unit.tile_position
	
	unit_tracker.erase(from_tile)
	unit_tracker[to_tile] = unit
	unit.tile_position=to_tile
	
	Events.emit_signal("unit_set_on_tile",unit,from_tile,to_tile)
	#map.get_cell_tile_data(tile_position).set_custom_data("Units",unit)



func spawn_unit(unit : Unit,tile_position):
	var BF=get_parent()
	unit.tile_position = tile_position
	add_child(unit)
	unit.initialize(BF)
