extends CustomTileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func spawn_unit(unit : Unit,tile_position):
	var BF=get_parent()
	unit.tile_position = tile_position
	add_child(unit)
	unit.initialize(BF)
