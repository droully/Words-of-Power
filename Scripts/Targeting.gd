extends Node

class_name Targeting

var caster:Unit
var BF
var spell_data :SpellData

enum targeting_methods {
	AreaOfEffect,
	PerpLine,
	PerpTShape,
	Cross
}

func targetable_tiles(_caster,_spell_data,_BF):
	self.caster=_caster
	self.spell_data=_spell_data
	self.BF=_BF
	
	
	match spell_data.targeting:
		targeting_methods.AreaOfEffect:
			return AOE()
		targeting_methods.Cross:
			return Cross()
	
	
func AOE():
	return BF.units.tiles_in_aoe(caster.tile_position,spell_data.srange,false,true)

func Cross():
	return BF.units.tiles_in_cross(caster.tile_position,spell_data.srange)
