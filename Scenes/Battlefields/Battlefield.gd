extends TileMap

class_name BattleField

enum Layer {Base,Highlight,PerTileData}
enum TileSetID {Battleground,Highlight,Coordinates}

@onready var units= $units

var Highlight_Layer = Layer.Highlight
var grid= AStarGrid2D.new()
var size_x
var size_y

var deployment_area = tiles_in_box(2,4,4,5)
func _ready():
	#set_layer_modulate(Layer.PerTileData,Color(1, 1, 1, 0))
	
	Events.unit_moved_global_coord.connect(_on_unit_moved_global_coord)
	setup(7,7)

func setup(x,y):

	size_x=x
	size_y=y	

	tile_set.add_custom_data_layer()
	tile_set.set_custom_data_layer_name(0,"UnitTracking")
	tile_set.set_custom_data_layer_type(0,22) #22=NodePath

	#set_per_tile_data(size_x,size_y)
	set_layer_z_index(Layer.PerTileData,-1)
	set_grid(size_x,size_y)	
	initialize_units()

func set_per_tile_data(x_lim,y_lim):
	for x in range(x_lim):
		for y in range(y_lim):
			set_cell(Layer.PerTileData,Vector2i(x,y),TileSetID.Coordinates,Vector2i(x,y))

func set_grid(x_lim,y_lim):
	grid.region= Rect2i(0, 0, x_lim, y_lim)
	
	grid.cell_size = Vector2(64, 64)
	grid.offset = Vector2(32,32)
	grid.default_compute_heuristic=1
	grid.default_estimate_heuristic=1
	grid.diagonal_mode=1
	grid.update()

	grid.set_point_solid(Vector2i(2,3))
	grid.set_point_solid(Vector2i(5,4))

func initialize_units():
	for unit in units.get_children():
		set_unit(unit)

func spawn_unit(unit : Unit,tile_position):
	unit.tile_position = tile_position
	units.add_child(unit)
	unit.initialize(self)
	get_cell_in_tile(unit.tile_position).set_custom_data("UnitTracking",unit)
	return true

func set_unit(unit : Unit):
	unit.initialize(self)
	get_cell_in_tile(unit.tile_position).set_custom_data("UnitTracking",unit)

func place_unit_on_tile(unit: Unit, tile_position_x:int, tile_position_y:int):
	#acepta posicion en tile desde el 0	
	var tile_position=Vector2i(tile_position_x,tile_position_y)
	var path = grid.get_point_path(unit.tile_position,tile_position)
	if len(path)>0:
		unit.move_through(path)
		unit.tile_position=tile_position
		return true
	return false

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
	var unit_tile = unit.tile_position # Assuming your unit has a 'tile_position' property
	
	# Check for horizontal alignment
	if unit_tile.y == target_tile.y:
		if unit_tile.x < target_tile.x:
			return Vector2i(1, 0) # Right
		else:
			return Vector2i(-1, 0) # Left

	# Check for vertical alignment
	elif unit_tile.x == target_tile.x:
		if unit_tile.y < target_tile.y:
			return Vector2i(0, 1) # Down
		else:
			return Vector2i(0, -1) # Up

	# Not on the same line
	else:
		return Vector2i(0, 0)

func get_cell_in_tile(tile_position: Vector2i): 
	return get_cell_tile_data(Layer.PerTileData,tile_position)

func get_unit_in_tile(tile_position: Vector2i):
	if tile_inside_BF(tile_position):
		
		var unit = get_cell_in_tile(tile_position).get_custom_data("UnitTracking")

		if is_instance_valid(unit):
			return unit
	return null

func is_tile_solid(tile):
	return grid.is_point_solid(tile)

func path_between_tiles(from_tile,to_tile):
	return grid.get_id_path(from_tile,to_tile)

func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)

func _on_unit_moved_global_coord(unit,from_coord:Vector2,to_coord:Vector2):
	var from_cell_coord=local_to_map(from_coord)
	var to_cell_coord=local_to_map(to_coord)
	
	var from_cell = get_cell_in_tile(from_cell_coord)
	var to_cell = get_cell_in_tile(to_cell_coord)
	
	from_cell.set_custom_data("UnitTracking",NodePath())
	to_cell.set_custom_data("UnitTracking",unit)
	
