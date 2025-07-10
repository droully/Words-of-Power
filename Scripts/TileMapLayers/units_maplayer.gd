extends BaseMapLayer

class_name UnitsMapLayer
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

func place_on_tile(unit: Unit, target_tile:Vector2i):
	#acepta posicion en tile desde el 0	
	
	var unit_in_target_tile = get_on_tile(target_tile)
	var path = [tile_to_position(unit.tile_position),tile_to_position(target_tile)]
	
	
	if unit_in_target_tile:
		return false #por mientras todo colisiona
	if unit_in_target_tile==unit:
		print("unit_in_target_tile = unit")


	if len(path)>0:
		unit.move_through(path)
		set_on_tile(unit,target_tile)

		#if unit_in_target_tile and unit_in_target_tile!=unit:
		#	return false
			#return collide_units(unit,unit_in_target_tile)
		return true
	return false


func spawn_unit(unit : Unit,tile_position):
	var BF=get_parent()
	unit.tile_position = tile_position
	add_child(unit)
	unit.initialize(BF)
