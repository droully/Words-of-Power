extends CustomTileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.groundbutton_pressed.connect(_on_groundbutton_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func is_tile_solid(tile):

	var tile_data =  get_cell_tile_data(tile)
	if tile_data !=null:
		var solid = tile_data.get_custom_data("Solid")
		return solid
	return false

func _on_groundbutton_pressed(_groundbutton,_tile_position):
	var cd=get_closed_doors()
	var od=get_open_doors()
	for door in cd:
		open_door(door)
	for door in od:
		close_door(door)

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
