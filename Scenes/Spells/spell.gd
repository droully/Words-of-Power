extends Node2D

class_name Spell

@onready var sprite=$Sprite

@export var spell_name: String = "base_spell"
@export var spell_name_UI: String = "Base Spell"
@export var cost: int = 1
@export var srange: int = 1
@export var duration: float = 1
@export var damage: int = 10
@export var radius: int = 1


var BF
var caster:Unit
var target_pos:Vector2

signal spell_cast_anim_start(spell)
signal spell_cast_anim_end(spell)

signal spell_effect(arg_dict)


func initialize(Battlefield,_caster:Unit,_target_pos:Vector2):
	BF=Battlefield
	caster=_caster
	target_pos=_target_pos

func animation():
	pass

func targeting(target_tile):
	var target_tiles=BF.tiles_in_aoe(target_tile, radius)
	var targets = []
	for tile in target_tiles:
		targets.append(BF.get_unit_in_tile(tile))
	return targets
	
func effect(target):
	var arg_dict ={"target":target, "damage":damage}
	emit_signal("spell_effect","attack",arg_dict)

