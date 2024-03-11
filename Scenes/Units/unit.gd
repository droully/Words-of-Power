extends Node2D

class_name Unit

@onready var ui = $UI
@onready var status_effects = $StatusEffects
@onready var sprite = $Sprite

# Enemy properties
@export var unit_name: String = "unit"
@export var hp: int = 100
@export var max_hp: int = 100
@export var temporal_hp: int = 0

@export var att: int = 10
@export var def: int = 5
@export var speed: int = 2
@export var shield: int = 0
@export var max_shield: int = 1
@export var priority: int = 2

@export var party: String = "enemy"

@export var side: String

var tile_position: Vector2i = Vector2i(-1,-1)


func _ready():
	pass

func initialize(BF: BattleField):
	if tile_position == Vector2i(-1,-1):
		tile_position = BF.position_to_tile(position)
	if position == Vector2(0,0):
		position = BF.tile_to_position(tile_position)
	
func walkable_tiles(BF):
	return BF.tiles_in_aoe(tile_position,speed,false,false)
	
func move_to(path):
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

func push( direction: Vector2i,BF):	
	var target_tile = tile_position + direction  # chequear colisiones
	var unit_target= BF.get_unit_in_tile(target_tile)
	if unit_target:
		take_damage(5)
		unit_target.take_damage(5)
		return 
	return BF.place_unit_on_tile(self, target_tile.x, target_tile.y)

func die():
	# Handle enemy death, e.g., play an animation, drop loot, etc.
	queue_free() # or handle in another way

func _on_finished_animation():
	Events.emit_signal("unit_move_anim_end",self)
