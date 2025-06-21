extends Node2D

class_name GroundButton

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
	tile_position = BF.groundbuttons.position_to_tile(position)
	BF.groundbuttons.set_groundbutton_on_tile(self,tile_position)
	self.initialized=true

func press():
	pressed = true
	Events.emit_signal("groundbutton_pressed",self,tile_position)
func unpress():
	pressed = false
	Events.emit_signal("groundbutton_unpressed",self,tile_position)
