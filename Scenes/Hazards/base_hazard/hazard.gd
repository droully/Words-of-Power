extends Node2D

class_name Hazard



var tile_position: Vector2i = Vector2i(-1,-1)
var BF:BattleField

@export var duration:int=-1
@export var hazard_name: String
func _ready():
	var bf=get_parent().get_parent()
	if bf.is_node_ready():
		initialize(bf)

func initialize(_BF: BattleField):
	self.BF=_BF
		
	if tile_position == Vector2i(-1,-1):
		tile_position = BF.hazards.position_to_tile(position)
	if position == Vector2(0,0):
		position = BF.hazards.tile_to_position(tile_position)
	BF.hazards.set_on_tile(self,tile_position)
	add_to_group("hazard")
		
func pass_turn():
	if duration == null:
		return
	else:
		duration -=1
		if duration==0:
			queue_free()

func affect_unit_on_top():
	var target =BF.units.get_on_tile(tile_position)
	if target:
		affect(target)

func affect(_target):
	pass
