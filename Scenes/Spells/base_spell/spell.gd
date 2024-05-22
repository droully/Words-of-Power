extends Node2D

class_name Spell

@onready var anim_player= $AnimationPlayer

@export var spell_data: SpellData 

var spell_name: String 
var spell_name_UI: String 
var cost: int
var srange: int 
var duration: float
var damage: int
var radius: int

var dir


var BF
var caster:Unit
var target_pos:Vector2
var target_tile:Vector2i

var affected_targets =[]

func initialize(_Battlefield,_caster:Unit,_target_pos:Vector2):
	self.BF=_Battlefield
	self.caster=_caster
	self.target_pos=_target_pos
	self.target_tile=BF.map.local_to_map(target_pos)
	
	self.spell_name = spell_data.spell_name
	self.spell_name_UI = spell_data.spell_name_UI
	self.cost = spell_data.cost
	self.srange = spell_data.srange
	self.duration = spell_data.duration
	self.damage = spell_data.damage
	self.radius = spell_data.radius
	 
	self.dir = BF.map.get_direction_from_unit_to_tile(caster,target_tile)

	
	
func affect_tiles():
	var affecting=Affecting.new()
	var l= affecting.affected_tiles(target_tile,caster, spell_data, BF)
	for tile in l:
		var unit_target= BF.map.get_unit_in_tile(tile)
		if unit_target:
			callbackOnHit(unit_target)
		callbackOnFloor(BF,tile)

func animation():
	return 
#borrar
func targetable_tiles(_caster=caster,_BF=BF):
	return null
	
func affected_tiles(_target_tile,_caster,_BF):
	return null
 
func effect(_target,_callback):
	return null

func callbackOnHit(_target):
	return null
func callbackOnFloor(_BF,_tile):
	return null
	
func _on_finished_animation(_anim_name):	
	Events.emit_signal("spell_cast_anim_end",self)	
	queue_free()

