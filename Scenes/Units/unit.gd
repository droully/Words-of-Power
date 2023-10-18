extends Node2D

class_name Unit

@onready var ui = $UI
@onready var status_effects = $StatusEffects
@onready var sprite = $Sprite

# Enemy properties
@export var unit_name: String = "unit"
@export var hp: int = 100
@export var max_hp: int = 100
@export var att: int = 10
@export var def: int = 5
@export var speed: int = 2
@export var shield: int = 0
@export var max_shield: int = 1


@export var sprite_frames: SpriteFrames
@export var side: String

var tile_position: Vector2i


func _ready():
	sprite.sprite_frames = sprite_frames

func set_attributes(_tile_position:Vector2i,_position):
	tile_position = _tile_position
	position = _position
	
func walkable_tiles(BF):
	return BF.tiles_in_aoe(tile_position,speed,false,false)
	
func move_to(path):
	var to_coord=path[-1]
	var from_coord= path[0] 
	
	Events.emit_signal("unit_moved",self,from_coord,to_coord)
	
	var tween = create_tween()
	tween.finished.connect(_on_finished_animation)
	
	Events.emit_signal("unit_move_anim_start",self)
	
	for point in path.slice(1):
		tween.tween_property(self, "position", point, .3)
	
#	position=to_coord	#position:absoluto


func take_damage(damage_amount: int,damage_type="neutral"):
	if shield>0:
		shield -=1
		ui.refresh()
		return
	
	damage_amount=damage_amount-self.def
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
	return BF.place_unit_on_tile(self, target_tile.x, target_tile.y)

func die():
	# Handle enemy death, e.g., play an animation, drop loot, etc.
	queue_free() # or handle in another way

func _on_finished_animation():
	Events.emit_signal("unit_move_anim_end",self)
