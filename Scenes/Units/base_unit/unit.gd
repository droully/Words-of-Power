extends Node2D

class_name Unit

@onready var ui = $UI
@onready var beh = $Behavior
@onready var status_effects = $StatusEffects
@onready var sprite=$Sprite
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
var element: String

var tags : Array
var initialized= false

var party: String = "enemy"

var BF : BattleField
var tile_position: Vector2i = Vector2i(-1,-1)


var tween: Tween

var orientation : Utils.Orientations = Utils.Orientations.UP:
	set(value): 
		orientation = value
		if has_node("Arrow"):
			$Arrow.rotation = Vector2(orientation_dir).angle()

var orientation_string: String:
	set(value): orientation=Utils.Orientations.get(value)
	get: return Utils.Orientations.find_key(orientation)

var orientation_dir: Vector2i:
	set(value): orientation=Utils.dir2vector.find_key(value)
	get: return Utils.dir2vector[orientation_string]

func _ready():
	var bf=get_parent().get_parent()
	orientation=orientation
	if bf.is_node_ready():
		initialize(bf)

func initialize(_BF: BattleField):
	if self.initialized:
		return
	
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
	self.element = unit_data.element
	self.initialized=true
	
	
	#beh.set_script(unit_data.behavior)
	
	if tile_position == Vector2i(-1,-1):
		tile_position = BF.units.position_to_tile(position)
	if position == Vector2(0,0):
		position = BF.units.tile_to_position(tile_position)
	BF.units.set_on_tile(self,tile_position)
	
	if name=="Player":
		party = "player"
	add_to_group(party)
	add_to_group("units")
	
	if name=="Player":
		Events.emit_signal("player_created",self)

func get_action(commands_list=[]):

	if beh.has_method("choose_command"):
		commands_list.append(beh.choose_command(BF))

func walkable_tiles():
	return BF.map.tiles_in_aoe(tile_position,speed,false,false,false)
	
func move_through(path:Array):
	#var to_coord = path[-1]
	#var from_coord = path[0] 
	
	tween = self.create_tween()
	tween.finished.connect(_on_finished_animation.bind(tween))
	
	Events.emit_signal("unit_move_anim_start",self,tween)
	for point in path.slice(1):
		tween.tween_property(self, "position", point, .3)
	
#	position=to_coord	#position:absoluto


func rotate_orientation(steps: int):
	orientation = Utils.rotate_dir(orientation_dir,steps)


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

func apply_status_effect():
	var status_list=get_node("StatusEffects").get_children()
	for status in status_list:
		status.per_turn_effect()
	for status in status_list:
		status.pass_turn()
		
func push(direction: Vector2i):	
	#retorna true si empuja, y la unidad con la que coliciona si coliciona 
	var target_tile = tile_position + direction  # chequear colisiones
	var target_unit =  BF.units.get_on_tile(target_tile)
	if target_unit:
		return target_unit
	return BF.place_unit_on_tile(self, target_tile)
	
func pull(direction: Vector2i):	
	return push(-direction)

func die():
	Events.emit_signal("unit_die",self)
	queue_free() # or handle in another way

func has_tag(tag:String):
	return tag in tags
	

func _on_finished_animation(anim):
	Events.emit_signal("unit_move_anim_end",self,anim)
	
