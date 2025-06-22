extends Node

class_name Command

class Cast:
	var command_name= "Caster"

	var caster
	var spell: Spell
	var spell_data: SpellData
	var target_tile
	var BF:BattleField
	var callback
	var AM
	var fast

	func _init(_caster:Unit,_spell_data:SpellData,_battlefield:BattleField,_fast=false):
		self.caster = _caster
		self.spell_data = _spell_data
		self.BF = _battlefield
		self.target_tile = BF.map.tile_in_front(_caster.tile_position,_caster.orientation_dir)
		self.fast = _fast
		
	func execute():
		self.spell=Utils.get_spell_by_name(spell_data.spell_name)
		spell.initialize(BF,caster,BF.map.map_to_local(target_tile))
		
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
	var command_name= "Move"

	var unit:Unit
	var target_tile
	var original_tile
	var BF:BattleField

	func _init(_unit, _target_tile, _battlefield):
		self.unit = _unit
		self.target_tile = _target_tile
		self.BF = _battlefield

	func execute():
		original_tile = unit.tile_position 
		if not BF.walls.is_tile_solid(target_tile):
			unit.orientation_string=Utils.dir2vector.find_key(target_tile - original_tile)
			#on_unit_collide()
			var placement = BF.place_unit_on_tile(unit, target_tile)
			if placement:
				Events.emit_signal("command_unit_moved",unit,original_tile,target_tile)
			return placement
		return false

class Deploy:
	var command_name= "Deploy"
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
	var command_name= "Skip"
	var unit
	
	func _init(_unit):
		self.unit=_unit
	func execute():
		return true
