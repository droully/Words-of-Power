extends TileMap

class_name Map

enum MapLayer {Base,Highlight,PerTileData}

#estan el map layer que son las capas de lo que se printea en pantalla
#estan el custom data layers que es la info del juego: Collision, UnitTracking,HazardTracking


var size_x
var size_y

var Highlight_Layer = MapLayer.Highlight

var grid= AStarGrid2D.new()

func _ready():
	
	Events.unit_moved_global_coord.connect(_on_unit_moved_global_coord)
	Events.debug.connect(_on_debug)
	setup(30,30)

func _on_debug():
	for tile in all_tiles():
		print(tile,get_collision_on_tile(tile))
		
func setup(x,y):

	size_x=x
	size_y=y

	
	tile_set.add_custom_data_layer(1)
	tile_set.set_custom_data_layer_name(1,"UnitTracking")
	tile_set.set_custom_data_layer_type(1,TYPE_NODE_PATH) 
	tile_set.add_custom_data_layer(2)
	tile_set.set_custom_data_layer_name(2,"HazardTracking")
	tile_set.set_custom_data_layer_type(2,TYPE_NODE_PATH) 
	

	#set_per_tile_data(size_x,size_y)
	set_layer_z_index(MapLayer.PerTileData,-1)
	set_grid(size_x,size_y)	

func set_grid(x_lim,y_lim):
	grid.region= Rect2i(0, 0, x_lim, y_lim)
	
	grid.cell_size = Vector2(64, 64)
	grid.offset = Vector2(32,32)
	grid.default_compute_heuristic=1
	grid.default_estimate_heuristic=1
	grid.diagonal_mode=1
	grid.update()

	for tile in all_tiles():
		if get_collision_on_tile(tile):
			grid.set_point_solid(tile)

func path_between_tiles(from_tile,to_tile):
	return grid.get_point_path(from_tile,to_tile)

func all_tiles():
	var tiles: Array = []
	for x in range(0,7):
		for y in range(0,7):
			tiles.append(Vector2i(x, y))
	return tiles

func mouse_to_tile(mouse_position: Vector2):	
	return local_to_map(to_local(mouse_position))

func position_to_tile(pos: Vector2):
	return local_to_map(pos)

func tile_to_position(tile_pos: Vector2i):
	return map_to_local(tile_pos)

func tile_inside_BF(tile_position: Vector2i):
	return grid.is_in_boundsv(tile_position)

func tiles_in_aoe_no_astar(center_tile: Vector2i, radius:int) -> Array:
	var tiles = []
	for x in range(center_tile.x - radius, center_tile.x + radius + 1):
		for y in range(center_tile.y - radius, center_tile.y + radius + 1):
			var tile= Vector2i(x, y)
			if not tile_inside_BF(tile):
				pass
			elif abs(tile.x - center_tile.x) + abs(tile.y - center_tile.y) <= radius:
				tiles.append(tile)
	return tiles

func tiles_in_aoe(center_tile: Vector2i, radius:int, return_solid_tiles=true, return_units=true,return_center=true):

	var tiles_no_astar = tiles_in_aoe_no_astar(center_tile,radius)
	var tiles = []

	var tiles_to_solid =[]
	if not return_units:
		for tile_to_solid in tiles_no_astar:
			if get_unit_in_tile(tile_to_solid):
				grid.set_point_solid(tile_to_solid)
				tiles_to_solid.append(tile_to_solid)

	for tile in tiles_no_astar:
		if not return_solid_tiles and grid.is_point_solid(tile):
			continue 
		if not return_units and get_unit_in_tile(tile):
			continue

		var path = grid.get_point_path(center_tile,tile)
		if (len(path)-1>radius):
			continue
		tiles.append(tile)
	if not return_center:
		tiles.erase(center_tile)

	for tile_to_desolid in tiles_to_solid:
		grid.set_point_solid(tile_to_desolid,false)
	return tiles

func tiles_in_box(x_start,y_start,x_end,y_end):
	var tiles = []
	for x in range(x_start, x_end + 1):
		for y in range(y_start, y_end + 1):
			tiles.append(Vector2i(x, y))
	return tiles

func tiles_in_line(center_tile: Vector2i, dir: Vector2i, length: int) -> Array:
	var tiles: Array = []

	for i in range(length):
		var next_tile = center_tile + dir * i
		if tile_inside_BF(next_tile):
			tiles.append(next_tile)
	return tiles

func tiles_in_cross(center_tile,length)->Array:
	var tiles: Array = []
	for y in [1,-1]:
		var dir = Vector2i(0,y)
		tiles += tiles_in_line(center_tile,dir,length)
	for x in [1,-1]:
		var dir = Vector2i(x,0)
		tiles += tiles_in_line(center_tile,dir,length)
	tiles.erase(center_tile)
	tiles.erase(center_tile)
	tiles.erase(center_tile)
	tiles.erase(center_tile)
	return tiles

func tiles_perpendicular(target_tile,dir,length):
	var tiles: Array = []
	var perp= Vector2i(dir.y,-dir.x)
	for i in range(2*length+1):
		i= i-length	
		var next_tile = target_tile + perp * i
		if tile_inside_BF(next_tile):
			tiles.append(next_tile)
	return tiles

func highlight_tiles(tiles,mask_atlas_coord:Vector2i):
	for tile in tiles:		
		if get_cell_source_id(Highlight_Layer, tile) ==-1:
			set_cell(Highlight_Layer,tile,1,mask_atlas_coord)

func reset_highlight(tiles: Array = all_tiles()):
	for tile in tiles:
		set_cell(Highlight_Layer,tile)

func get_direction_from_unit_to_tile(unit: Unit, target_tile: Vector2i) -> Vector2i:
	var unit_tile = unit.tile_position 
	
	if unit_tile.y == target_tile.y:
		if unit_tile.x < target_tile.x:
			return Vector2i(1, 0) # Right
		else:
			return Vector2i(-1, 0) # Left

	elif unit_tile.x == target_tile.x:
		if unit_tile.y < target_tile.y:
			return Vector2i(0, 1) # Down
		else:
			return Vector2i(0, -1) # Up

	# Not on the same line
	else:
		return Vector2i(0, 0)

func get_cell_in_tile(tile_position: Vector2i, maplayer= MapLayer.PerTileData): 
	return get_cell_tile_data(maplayer,tile_position)

func get_hazard_in_tile(tile_position: Vector2i)->Hazard:
	if tile_inside_BF(tile_position):
		var hazard = get_cell_in_tile(tile_position).get_custom_data("HazardTracking")
		if is_instance_valid(hazard):
			return hazard
	return null

func get_unit_in_tile(tile_position: Vector2i)->Unit:
	if tile_inside_BF(tile_position):
		var unit = get_cell_in_tile(tile_position).get_custom_data("UnitTracking")
		if is_instance_valid(unit):
			return unit
	return null
	
func set_unit_on_tile(tile:Vector2i,unit=NodePath()):
	get_cell_in_tile(tile).set_custom_data("UnitTracking",unit)
	
func set_hazard_on_tile(tile:Vector2i,hazard=NodePath()):
	get_cell_in_tile(tile).set_custom_data("HazardTracking",hazard)
	
func get_collision_on_tile(tile_position:Vector2i):
	return get_cell_in_tile(tile_position,MapLayer.Base).get_custom_data("Collision")
	
func is_tile_solid(tile):
	return grid.is_point_solid(tile)
	

#func set_per_tile_data(x_lim,y_lim):
	#for x in range(x_lim):
		#for y in range(y_lim):
			#set_cell(Layer.PerTileData,Vector2i(x,y),TileSetID.Coordinates,Vector2i(x,y))

func _on_unit_moved_global_coord(unit,from_coord:Vector2,to_coord:Vector2):
	var from_tile=local_to_map(from_coord)
	var to_tile=local_to_map(to_coord)
	set_unit_on_tile(from_tile)
	set_unit_on_tile(to_tile,unit)
	
