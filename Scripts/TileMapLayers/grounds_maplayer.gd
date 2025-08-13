extends BaseMapLayer

class_name GroundsMapLayer

var ground_tracker ={}

func _ready():
	Events.unit_set_on_tile.connect(_on_unit_set_on_tile)
	Events.ground_destroyed.connect(_on_ground_destroyed)
	

func get_end_portals():
	var l =[]
	for ground in get_children():
		if ground.has_tag("Portal"):
			l.append(ground)
	return l

func erase_on_tile(tile:Vector2i):
	ground_tracker.erase(tile)

func set_on_tile(ground:Ground,tile:Vector2i):
	erase_on_tile(ground.tile_position)
	ground_tracker[tile] = ground
	ground.tile_position=tile

func get_on_tile(tile_position:Vector2i)->Ground:
	return ground_tracker.get(tile_position)
	
func place_on_tile(ground: Ground, target_tile:Vector2i):	
	var ground_in_target_tile = get_on_tile(target_tile)
	var path = [tile_to_position(ground.tile_position),tile_to_position(target_tile)]

	if ground_in_target_tile:
		return false #por mientras todo colisiona
	if ground_in_target_tile==ground:
		print("ground_in_target_tile = ground")

	if len(path)>0:
		ground.move_through(path)
		set_on_tile(ground,target_tile)

		return true
	return false

func _on_ground_destroyed(ground:Ground):
	erase_on_tile(ground.tile_position)
	
	
func _on_unit_set_on_tile(_unit:Unit,from_tile:Vector2i,to_tile:Vector2i):
	var to_ground=get_on_tile(to_tile)
	var from_ground=get_on_tile(from_tile)
	
	if from_ground !=null:
		from_ground.on_ground_exited()
	if to_ground != null:
		to_ground.on_ground_entered()
	
	
