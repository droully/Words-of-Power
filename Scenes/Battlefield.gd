extends TileMap
# A dictionary to track which tiles are occupied and by which units.
#var occupied_tiles: Dictionary = {}

enum Layer {Base,Highlight,Meta}

@onready var player=$Player
@onready var enemy=$Enemy
@onready var BM = get_node("../BattleManager")


var limit_min=Vector2i(0,0)
var limit_max=Vector2i(6,6)
var last_highlighted_tile = Vector2i(-1, -1)

func _ready():
	set_layer_modulate(Layer.Meta,Color(1, 1, 1, 0))
	
	Events.unit_moved.connect(_on_unit_moved)
	
	place_unit_on_tile(enemy,3,2)
	place_unit_on_tile(player,3,4)

func place_unit_on_tile(unit, tile_position_x:int, tile_position_y:int):
	#acepta posicion en tile desde el 0	
	var tile_position=Vector2i(tile_position_x,tile_position_y)
	tile_position=tile_position.clamp(limit_min,limit_max)		
	var target_destination = map_to_local(tile_position)
	
	unit.move_to(target_destination)
	unit.tile_position=tile_position
	return true

func all_tiles():
	var tiles: Array = []
	for x in range(0,7):
		for y in range(0,7):
			tiles.append(Vector2i(x, y))
	return tiles


func mouse_to_tile(mouse_position: Vector2):
	return local_to_map(to_local(mouse_position))

func tile_inside_BF(tile_position: Vector2i):
	return tile_position==tile_position.clamp(limit_min,limit_max) 
	
func tiles_in_aoe(center_tile: Vector2i, radius:int) -> Array:
	var tiles: Array = []

	for x in range(center_tile.x - radius, center_tile.x + radius + 1):
		for y in range(center_tile.y - radius, center_tile.y + radius + 1):
			var tile= Vector2i(x, y)
			if not tile_inside_BF(tile):
				pass
			elif abs(tile.x - center_tile.x) + abs(tile.y - center_tile.y) <= radius:
				tiles.append(tile)

	return tiles


func tiles_in_line(center_tile: Vector2i, dir: Vector2i, length: int) -> Array:
	var tiles: Array = []

	for i in range(length):
		var next_tile = center_tile + dir * i
		if tile_inside_BF(next_tile):
			tiles.append(next_tile)
	return tiles
	
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
	return get_cell_tile_data(Layer.Meta,tile_position)

func get_unit_in_tile(tile_position: Vector2i):
	if tile_inside_BF(tile_position):
		var unit = get_cell_in_tile(tile_position).get_custom_data("UnitTracking")
		if is_instance_valid(unit):
			return unit
	return null

func distance(tile1: Vector2i, tile2: Vector2i):
	return abs(tile1.x - tile2.x) + abs(tile1.y - tile2.y)

func _on_unit_moved(unit,from_coord:Vector2,to_coord:Vector2):

	var from_cell = get_cell_in_tile(local_to_map(from_coord))
	var to_cell = get_cell_in_tile(local_to_map(to_coord))
	from_cell.set_custom_data("UnitTracking",null)
	to_cell.set_custom_data("UnitTracking",unit)

