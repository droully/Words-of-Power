extends Command
class_name CastCommand

var caster
var spell
var target_tile
var BF
var callback

func _init(_caster:Unit,_spell:Spell,_target_tile,_battlefield,_callback):
	self.caster = _caster
	self.spell = _spell
	self.target_tile = _target_tile
	self.BF = _battlefield
	self.callback=_callback
	
func execute():
	spell.initialize(BF,caster,BF.map_to_local(target_tile))
	BF.add_child(spell)
	spell.hide()
	#spell.valid_target_tile(callback)

	if BF.distance(target_tile,caster.tile_position)>spell.srange:
		return false
		
	spell.show()
	
	#targets=spell.get_targets(callback)
	var targets = spell.targeting(target_tile)
	
	
	for target in targets:
		if target:
			spell.effect(target,callback)
	#affect target
	spell.animation()
	return true
