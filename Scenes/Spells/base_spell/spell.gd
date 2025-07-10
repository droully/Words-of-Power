extends Node2D
class_name Spell

@onready var anim_player : AnimationPlayer = $AnimationPlayer 

@export var spell_data : SpellData 

var spell_name: String 
var spell_name_UI: String 
var cost: int
var srange: int 
var duration: float
var damage: int
var radius: int

var dir

var BF : BattleField
var caster:Unit
var finished= false
var affected_targets =[]
var affected_tiles

func initialize(_Battlefield,_caster:Unit):
	self.BF=_Battlefield
	self.caster=_caster
	
	self.affected_tiles = Affecting.new().affected_tiles(caster, spell_data, BF)

	self.spell_name = spell_data.spell_name
	self.spell_name_UI = spell_data.spell_name_UI
	self.cost = spell_data.cost
	self.srange = spell_data.srange
	self.duration = spell_data.duration
	self.damage = spell_data.damage
	self.radius = spell_data.radius

	self.dir = caster.orientation_dir



func affect_tiles():
	for tile in affected_tiles:
		if finished:
			break
		var unit_target= BF.units.get_on_tile(tile)
		if unit_target:
			callbackOnHit(unit_target)
		callbackOnFloor(BF,tile)


func animation():
	return 
#borrar
func targetable_tiles(_caster=caster,_BF=BF):
	return null

func effect(_target,_callback):
	return null

func callbackOnHit(_target):
	return null
func callbackOnFloor(_BF,_tile):
	return null
	
func _on_finished_animation(_anim_name):	
	Events.emit_signal("spell_cast_anim_end",self,anim_player)	
	queue_free()
