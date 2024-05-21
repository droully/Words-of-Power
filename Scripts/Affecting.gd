extends Node

class_name Affecting

var caster:Unit
var BF
var target_tile
var spell_data :SpellData

func affected_tiles(_target_tile,_caster,_spell_data,_BF):
	self.caster=_caster
	self.spell_data=_spell_data
	self.BF=_BF
	self.target_tile=_target_tile
	
	
	match spell_data.affecting:
		SpellData.affecting_methods.AreaOfEffect:
			return AreaOfEffect()
		SpellData.affecting_methods.ForwardSegment:
			return ForwardSegment()
		SpellData.affecting_methods.PerpTShape:
			return PerpTShape()
		SpellData.affecting_methods.SingleTarget:
			return SingleTarget()

func SingleTarget():
	return [target_tile]
	
func AreaOfEffect():
	if BF.grid.is_point_solid(target_tile):
		return []
	return BF.tiles_in_aoe(target_tile, spell_data.radius,false,true)

func ForwardSegment():
	var dir = BF.get_direction_from_unit_to_tile(caster,target_tile)
	var tiles=BF.tiles_in_line(target_tile,dir, spell_data.radius)
	return tiles
	
func PerpTShape():
	var dir = BF.get_direction_from_unit_to_tile(caster,target_tile)
	var tiles=BF.tiles_perpendicular(target_tile,dir, spell_data.radius)

	return tiles
