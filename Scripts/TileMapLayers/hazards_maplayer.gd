extends BaseMapLayer

class_name HazardMapLayer
var hazard_tracker ={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func spawn_hazard(hazard : Hazard,tile_position):
	var BF=get_parent()
	hazard.tile_position = tile_position
	add_child(hazard)
	hazard.initialize(BF)

func set_on_tile(hazard :Hazard,tile_position:Vector2i):
	hazard_tracker.erase(hazard.tile_position)
	hazard_tracker[tile_position] = hazard

func get_on_tile(tile_position:Vector2i):
	return hazard_tracker.get(tile_position)
