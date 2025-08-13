extends Node

class_name Affecting

var caster:Unit
var BF : BattleField
var spell_data :SpellData

enum affecting_methods {
	AreaOfEffect,
	ForwardSegment,
	PerpTShape,
	SingleTarget,
	Sides,
	FirstOccupied
}

func affected_tiles(_caster,_spell_data,_BF):
	self.caster=_caster
	self.spell_data=_spell_data
	self.BF=_BF

	match spell_data.affecting:
		affecting_methods.AreaOfEffect:
			return AreaOfEffect()
		affecting_methods.ForwardSegment:
			return ForwardSegment()
		affecting_methods.PerpTShape:
			return PerpTShape()
		affecting_methods.SingleTarget:
			return SingleTarget()
		affecting_methods.Sides:
			return Sides()
		affecting_methods.FirstOccupied:
			return FirstOccupied()

func SingleTarget():
	pass
	#return [target_tile]

func AreaOfEffect():
	pass
	#if BF.is_tile_solid(target_tile):
		#return []
	#return BF.map.tiles_in_aoe(target_tile, spell_data.radius,false,true)

func FirstOccupied():
	var dir = caster.orientation_dir
	var tiles=BF.map.tiles_in_line(caster.tile_position+dir,dir, spell_data.radius)
	for tile in tiles:
		if BF.units.get_on_tile(tile):
			return [tile]
		if BF.is_tile_solid(tile):
			return[tile]
	return [tiles[-1]]

func ForwardSegment():
	#var dir = BF.map.get_direction_from_tile_to_tile(caster.tile_position,target_tile)
	var dir = caster.orientation_dir
	var tiles=BF.map.tiles_in_line(caster.tile_position+dir,dir, spell_data.radius)
	return tiles

func Sides():
	var tiles = BF.map.get_sides(caster.tile_position,caster.orientation_dir)
	return tiles

func PerpTShape():
	pass
	#var dir = BF.map.get_direction_from_tile_to_tile(caster.tile_position,target_tile)
	#var tiles=BF.map.tiles_perpendicular(target_tile,dir, spell_data.radius)
	#return tiles
