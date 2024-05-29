extends Node2D

class_name Hazard




var tile_position: Vector2i = Vector2i(-1,-1)
var BF:BattleField




func initialize(_BF: BattleField):
	self.BF=_BF
		
	if tile_position == Vector2i(-1,-1):
		tile_position = BF.map.position_to_tile(position)
	if position == Vector2(0,0):
		position = BF.map.tile_to_position(tile_position)
		
		
		
func affect_unit(unit:Unit):
	pass
