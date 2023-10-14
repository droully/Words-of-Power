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


func initialize(_Battlefield,_caster:Unit,_target_pos:Vector2):
	self.BF=_Battlefield
	self.caster=_caster
	self.target_pos=_target_pos
	
func animation():
	return null

func targeting(_target_tile):
	return null
	
func effect(_target,_callback):
	return null
