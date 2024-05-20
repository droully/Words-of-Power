extends Node2D

class_name Unit

enum Orientation {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@onready var ui = $UI
@onready var status_effects = $StatusEffects

# Enemy properties

@export var unit_data: UnitData 


var unit_name : String
var hp : int
var max_hp : int
var temporal_hp : int
var att : int
var def : int
var speed : int
var shield : int
var max_shield : int
var priority : int

var tags : Array

@export var party: String = "enemy"

@export var side: String

var BF : BattleField
var tile_position: Vector2i = Vector2i(-1,-1)
var orientation = Orientation.LEFT

func _ready():
	pass

func initialize(_BF: BattleField):
	self.BF=_BF
	
	self.unit_name = unit_data.unit_name
	self.hp = unit_data.hp
	self.max_hp = unit_data.max_hp
	self.temporal_hp = unit_data.temporal_hp
	self.att = unit_data.att
	self.def = unit_data.def
	self.speed = unit_data.speed
	self.shield = unit_data.shield
	self.max_shield = unit_data.max_shield
	self.priority = unit_data.priority
	self.tags = unit_data.tags

	if tile_position == Vector2i(-1,-1):
		tile_position = BF.position_to_tile(position)
	if position == Vector2(0,0):
		position = BF.tile_to_position(tile_position)
	
func walkable_tiles():
	return BF.tiles_in_aoe(tile_position,speed,false,false)
	
func move_through(path):
	var to_coord=path[-1]
	var from_coord= path[0] 
	
	Events.emit_signal("unit_moved_global_coord",self,from_coord,to_coord)
	
	var tween = create_tween()
	tween.finished.connect(_on_finished_animation)
	
	Events.emit_signal("unit_move_anim_start",self)
	
	for point in path.slice(1):
		tween.tween_property(self, "position", point, .3)
	
#	position=to_coord	#position:absoluto


func take_damage(damage_amount: int,_damage_type="neutral"):
	if shield>0:
		shield -=1
		ui.refresh()
		return
	
#	damage_amount=damage_amount-self.def
	hp -= damage_amount
	ui.refresh()
	
	if hp <= 0:
		die()
	return true
func increase_shield():
	shield +=1
	shield= clamp(shield, 0, max_shield)
	ui.refresh()

func add_status_effect(status):
	status_effects.add_child(status)
	status.name = status.effect_name
	status.apply_effect()
	ui.refresh()

func remove_status_effect(status):
	status_effects.status.queue_free()
	status.remove_effect()
	ui.refresh()

func push( direction: Vector2i):	
	#retorna true si empuja, y la unidad con la que coliciona si coliciona 
	var target_tile = tile_position + direction  # chequear colisiones
	var target_unit =  BF.get_unit_in_tile(target_tile)
	if target_unit:
		return target_unit
	return BF.place_unit_on_tile(self, target_tile.x, target_tile.y)
	
func pull(direction: Vector2i):	
	return push(-direction)

func die():
	Events.emit_signal("unit_die",self)
	# Handle enemy death, e.g., play an animation, drop loot, etc.
	queue_free() # or handle in another way

func has_tag(tag:String):
	return tag in tags
	

func _on_finished_animation():
	Events.emit_signal("unit_move_anim_end",self)