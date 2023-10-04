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


signal unit_moved(unit,from_coord,to_coord)
signal unit_move_anim_start(unit)
signal unit_move_anim_end(unit)

func _ready():
	$Sprite.sprite_frames = sprite_frames
	ui.refresh(self)
	
func move_to(to_coord:Vector2):
	var tween = create_tween()
	tween.finished.connect(_on_finished_animation)
	#a absoluto 
	var from_coord= position #
	emit_signal("unit_move_anim_start",self)
	tween.tween_property(self, "position", to_coord, .3).set_trans(Tween.TRANS_BACK)
	
#	position=to_coord	#position:absoluto
	emit_signal("unit_moved",self,from_coord,to_coord)
	


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
	emit_signal("unit_move_anim_end",self)
