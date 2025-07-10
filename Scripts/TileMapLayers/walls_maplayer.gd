extends BaseMapLayer

class_name WallsMapLayer
# Called when the node enters the scene tree for the first time.
var doors = []
var blocked_doors = []
var buttons_pressed = 0

func _ready() -> void:
	Events.unit_set_on_tile.connect(_on_unit_set_on_tile)
	Events.button_pressed.connect(_on_button_pressed)
	Events.button_unpressed.connect(_on_button_unpressed)
	doors = get_closed_doors() + get_open_doors()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func is_tile_solid(tile):
	var tile_data =  get_cell_tile_data(tile)
	if tile_data !=null:
		var solid = tile_data.get_custom_data("Solid")
		return solid
	return false

func check_door_state(door):
	if door in get_closed_doors():
		if buttons_pressed==1:
			open_door(door)

	elif door in get_open_doors():
		if (buttons_pressed==0) and (door not in blocked_doors):
			close_door(door)


func block_door(door):
	blocked_doors.append(door)
	
func unblock_door(door):
	blocked_doors.erase(door)


func get_closed_doors():
	return get_used_cells_by_id(1,Vector2i.ZERO)
func get_open_doors():
	return get_used_cells_by_id(2,Vector2i.ZERO)

func destroy_wall(tile):
	set_cell(tile)

func close_door(tile):
	set_cell(tile,1,Vector2i.ZERO)

func open_door(tile):
	set_cell(tile,2,Vector2i.ZERO)

func _on_unit_set_on_tile(_unit,from_tile,to_tile):
	if from_tile in doors:
		unblock_door(from_tile)
		check_door_state(from_tile)
	if to_tile in doors:
		block_door(to_tile)
		check_door_state(from_tile)


func _on_button_pressed(_button,_tile_position):
	buttons_pressed+=1
	for door in doors:
		check_door_state(door)
		
func _on_button_unpressed(_button,_tile_position):
	buttons_pressed-=1
	for door in doors:
		check_door_state(door)
