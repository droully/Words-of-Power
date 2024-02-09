extends Resource

class_name Spell2

@export var sprite:SpriteFrames
@export var anim_player: Callable


@export var spell_name: String = "base_spell"
@export var spell_name_UI: String = "Base Spell"
@export var cost: int = 1
@export var srange: int = 1
@export var duration: float = 1
@export var damage: int = 10
@export var radius: int = 1

@export var onHit : Effect


var BF
var caster:Unit
var target_pos:Vector2

var affected_targets =[]


func initialize(_Battlefield,_caster:Unit,_target_pos:Vector2):
	self.BF=_Battlefield
	self.caster=_caster
	self.target_pos=_target_pos
	
func affect_tiles():
	for tile in affected_tiles(BF.local_to_map(target_pos),caster,BF):
		var unit_target= BF.get_unit_in_tile(tile)
		if unit_target:
			callbackOnHit(unit_target)
		callbackOnFloor(BF,tile)

func animation():
	return 

func targeteable_tiles(_caster=caster,_BF=BF):
	return null
	
func affected_tiles(_target_tile,_caster,_BF):
	return null

func effect(_target,_callback):
	return null

func callbackOnHit(_target):
	return onHit.call(_target)
	
func callbackOnFloor(_BF,_tile):
	return null
	
func _on_finished_animation(_anim_name):	
	Events.emit_signal("spell_cast_anim_end",self)	

