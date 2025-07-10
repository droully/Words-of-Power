extends TileMapLayer

class_name BaseMapLayer

var size_x = 30
var size_y = 30



func all_tiles():
	var tiles: Array = []
	for x in range(0,size_x):
		for y in range(0,size_y):
			tiles.append(Vector2i(x, y))
	return tiles

func mouse_to_tile(mouse_position: Vector2):	
	return local_to_map(to_local(mouse_position))

func position_to_tile(pos: Vector2):
	return local_to_map(pos)

func tile_to_position(tile_pos: Vector2i):
	return map_to_local(tile_pos)
	
func map_to_global(tile_pos:Vector2i)->Vector2:
	return to_global(map_to_local(tile_pos))
	
func tile_inside_BF(tile_position: Vector2i):
	return tile_position.x >= 0 and tile_position.x < size_x and tile_position.y >= 0 and tile_position.y < size_y

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

func tiles_in_aoe(center_tile: Vector2i, radius: int, _return_solid_tiles=true, _return_units=true, return_center=true):
	var tiles = []
	var visited = {}
	var queue = []

	queue.append([center_tile, 0])
	visited[center_tile] = true

	while queue.size() > 0:
		var pop = queue.pop_front()
		var current_tile=pop[0]
		var current_distance=pop[1]
		if current_distance > radius:
			continue
		#if return_solid_tiles or not is_tile_solid(current_tile):
		#	if return_units or not get_unit_on_tile(current_tile):
		tiles.append(current_tile)
		for neighbor in get_neighbors(current_tile):
			if neighbor in visited:
				continue
			visited[neighbor] = true
			queue.append([neighbor, current_distance + 1])
	if not return_center:
		tiles.erase(center_tile)
	return tiles

func get_neighbors(tile: Vector2i):
	var neighbors = []
	var directions = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	for direction in directions:
		var neighbor = tile + direction
		neighbors.append(neighbor)
	return neighbors
	
func get_sides(tile: Vector2i,front_dir:Vector2i):
	var sides= [tile+Utils.rotate_dir(front_dir,1),tile+Utils.rotate_dir(front_dir,-1)]
	return sides

func get_direction_from_tile_to_tile(from_tile: Vector2i, to_tile: Vector2i) -> Vector2i:

	if from_tile.y == to_tile.y:
		if from_tile.x < to_tile.x:
			return Vector2i(1, 0) # Right
		else:
			return Vector2i(-1, 0) # Left

	elif from_tile.x == to_tile.x:
		if from_tile.y < to_tile.y:
			return Vector2i(0, 1) # Down
		else:
			return Vector2i(0, -1) # Up

	# Not on the same line
	else:
		return Vector2i(1, 0)
		
func tile_in_front(from_tile: Vector2i, dir: Vector2i):
	return from_tile+dir

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
	
