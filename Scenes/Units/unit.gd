extends Node2D

class_name Unit

@onready var ui = $UI

# Enemy properties
@export var unit_name: String = "unit"
@export var hp: int = 100
@export var max_hp: int = 100
@export var att: int = 10
@export var def: int = 5
@export var speed: int = 2

@export var sprite_frames: SpriteFrames
@export var side: String

var tile_position: Vector2i



func _ready():
	$Sprite.sprite_frames = sprite_frames
	ui.refresh(self)
	
func set_attributes(_tile_position:Vector2i,_position):
	tile_position = _tile_position
	position = _position
func move_to(path):
	var to_coord=path[-1]
	var from_coord= position 
	
	var tween = create_tween()
	tween.finished.connect(_on_finished_animation)
	
	Events.emit_signal("unit_move_anim_start",self)
	
	for point in path.slice(1):
		tween.tween_property(self, "position", point, .3)
	
#	position=to_coord	#position:absoluto
	Events.emit_signal("unit_moved",self,from_coord,to_coord)
	


func take_damage(damage_amount: int):
	damage_amount=damage_amount-self.def
	hp -= damage_amount
	ui.refresh(self)
	
	if hp <= 0:
		die()
		


		
func die():
	# Handle enemy death, e.g., play an animation, drop loot, etc.
	queue_free() # or handle in another way

func _on_finished_animation():
	Events.emit_signal("unit_move_anim_end",self)
