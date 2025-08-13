extends Node2D

class_name Ground

var BF : BattleField
var initialized = false

var pressed = false
@export var walkable : bool
@export var pushable : bool
@export var grabable : bool
@export var solid : bool
var tile_position: Vector2i = Vector2i(-1,-1)

@export var tags : Array[String]

func _ready():
	var bf=get_parent().get_parent()

	Events.unit_set_on_tile.connect(_on_unit_set_on_tile)

	if bf.is_node_ready():
		initialize(bf)


func initialize(_BF: BattleField):
	if self.initialized:
		return
	BF=_BF
	tile_position = BF.grounds.position_to_tile(position)
	BF.grounds.set_on_tile(self,tile_position)
	self.initialized=true

func move_through(path:Array):
	#var to_coord = path[-1]
	#var from_coord = path[0] 
	
	var tween = self.create_tween()
	tween.finished.connect(_on_finished_animation.bind(tween))
	
	Events.emit_signal("ground_move_anim_start",self,tween)
	for point in path.slice(1):
		tween.tween_property(self, "position", point, .3)

func _on_finished_animation(anim):
	Events.emit_signal("ground_move_anim_end",self,anim)
	
func has_tag(tag:String):
	return tag in tags

func _on_unit_set_on_tile(_unit,from_tile,to_tile):
	if from_tile == tile_position:
		on_ground_exited()
	if to_tile == tile_position:
		on_ground_entered()
	

func on_ground_entered():
	pass

func on_ground_exited():
	pass
