extends CustomTileMapLayer


var ground_tracker ={}
func _ready():
	Events.unit_set_on_tile.connect(_on_unit_set_on_tile)


func set_ground_on_tile(ground:Ground,target_tile:Vector2i):
	ground_tracker.erase(ground.tile_position)
	ground_tracker[target_tile] = ground
	ground.tile_position=target_tile

func get_ground_on_tile(tile_position:Vector2i)->Ground:
	return ground_tracker.get(tile_position)
	
	
func _on_unit_set_on_tile(_unit:Unit,from_tile:Vector2i,to_tile:Vector2i):
	var to_ground=get_ground_on_tile(to_tile)
	var from_ground=get_ground_on_tile(from_tile)
	if from_ground !=null:
		from_ground.unstep()
	
	if to_ground != null:
		to_ground.step()
	
	
