extends Node

class_name Command

class Cast:

	var caster
	var spell
	var target_tile
	var BF
	var callback
	var AM
	var fast

	func _init(_caster:Unit,_spell:Spell,_target_tile,_battlefield,_fast=false):
		self.caster = _caster
		self.spell = _spell
		self.target_tile = _target_tile
		self.BF = _battlefield
		self.fast = _fast
	func execute():
		spell.initialize(BF,caster,BF.map_to_local(target_tile))
		BF.add_child(spell)

		spell.hide()
		if target_tile not in spell.targeteable_tiles():
			return false
		spell.show()
		Events.emit_signal("command_spell_casted",caster,spell,target_tile)
		#affect target
		if fast:
			spell.affect_tiles()
			return true

		else:
			spell.animation()
			return true

class Move:

	var unit
	var target_tile
	var original_tile
	var BF

	func _init(_unit, _target_tile, _battlefield):
		self.unit = _unit
		self.target_tile = _target_tile
		self.BF = _battlefield

	func execute():
		original_tile = unit.tile_position  # Store the original position before the move
		if target_tile in unit.walkable_tiles(BF):	
			
			Events.emit_signal("command_unit_moved",unit,original_tile,target_tile)
			return BF.place_unit_on_tile(unit, target_tile.x, target_tile.y)
		return false

