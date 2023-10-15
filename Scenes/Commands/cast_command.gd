extends Command
class_name CastCommand

var caster
var spell
var target_tile
var BF
var callback


func _init(_caster:Unit,_spell:Spell,_target_tile,_battlefield):
	self.caster = _caster
	self.spell = _spell
	self.target_tile = _target_tile
	self.BF = _battlefield

func execute():
	spell.initialize(BF,caster,BF.map_to_local(target_tile))
	BF.add_child(spell)

	spell.hide()
	#spell.valid_target_tile(callback)
	if target_tile not in spell.targeteable_tiles():
		return false
		
	spell.show()

	var affected_tiles = spell.affected_tiles(target_tile,caster,BF)

	for tile in affected_tiles:
		var unit_target= BF.get_unit_in_tile(tile)
		if unit_target:
			if spell.has_method("callbackOnHit"):
				spell.callbackOnHit(unit_target)
				spell.affected_targets.append(unit_target)
	#affect target
	spell.animation()
	return true
