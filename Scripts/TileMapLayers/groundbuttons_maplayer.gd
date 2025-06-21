extends CustomTileMapLayer


var groundbutton_tracker ={}
func _ready():
	Events.unit_set_on_tile.connect(_on_unit_set_on_tile)


func set_groundbutton_on_tile(groundbutton:GroundButton,target_tile:Vector2i):
	groundbutton_tracker.erase(groundbutton.tile_position)
	groundbutton_tracker[target_tile] = groundbutton
	groundbutton.tile_position=target_tile

func get_groundbutton_on_tile(tile_position:Vector2i)->GroundButton:
	return groundbutton_tracker.get(tile_position)
	
	
func _on_unit_set_on_tile(_unit:Unit,from_tile:Vector2i,to_tile:Vector2i):
	var to_groundbutton=get_groundbutton_on_tile(to_tile)
	var from_groundbutton=get_groundbutton_on_tile(from_tile)
	if from_groundbutton !=null:
		from_groundbutton.unpress()
	
	if to_groundbutton != null:
		to_groundbutton.press()
	
	
