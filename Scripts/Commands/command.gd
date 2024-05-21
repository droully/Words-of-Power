extends Node

class_name Command

class Cast:

	var caster
	var spell: Spell
	var spell_data: SpellData
	var target_tile
	var BF:BattleField
	var callback
	var AM
	var fast

	func _init(_caster:Unit,_spell_data:SpellData,_target_tile,_battlefield,_fast=false):
		self.caster = _caster
		self.spell_data = _spell_data
		self.target_tile = _target_tile
		self.BF = _battlefield
		self.fast = _fast
		
	func execute():
		self.spell=Utils.get_spell_by_name(spell_data.spell_name)
		spell.initialize(BF,caster,BF.map_to_local(target_tile))
		BF.add_child(spell)

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
		if target_tile in unit.walkable_tiles():
			Events.emit_signal("command_unit_moved",unit,original_tile,target_tile)
			return BF.place_unit_on_tile(unit, target_tile.x, target_tile.y)
		return false

class Deploy:

	var unit : Unit
	var unit_data : UnitData
	var target_tile
	var BF

	func _init(_unit_data, _target_tile, _battlefield):
		self.unit_data = _unit_data
		self.target_tile = _target_tile
		self.BF = _battlefield

	func execute():
		self.unit=Utils.get_unit_by_name(unit_data.unit_name)
		BF.spawn_unit(unit,target_tile)

		Events.emit_signal("command_unit_deployed",unit)
		return true

class Skip: 
	var unit
	
	func _init(_unit):
		self.unit=_unit
	func execute():
		return true
