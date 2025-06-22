extends Node2D

class_name Ground

var BF : BattleField
var initialized = false

var pressed = false
var tile_position: Vector2i = Vector2i(-1,-1)


func _ready():
	var bf=get_parent().get_parent()
	if bf.is_node_ready():
		initialize(bf)

func initialize(_BF: BattleField):
	if self.initialized:
		return
	BF=_BF
	tile_position = BF.grounds.position_to_tile(position)
	BF.grounds.set_ground_on_tile(self,tile_position)
	self.initialized=true

func step():
	pressed = true
	Events.emit_signal("button_pressed",self,tile_position)
	
func unstep():
	pressed = false
	Events.emit_signal("button_unpressed",self,tile_position)
