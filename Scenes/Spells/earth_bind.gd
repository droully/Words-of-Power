extends Spell

@onready var anim_player= $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass
	

func targeteable_tiles(_caster=caster,_BF=BF):
	return _BF.tiles_in_aoe(_caster.tile_position,srange,false,true)
	
func affected_tiles(target_tile,_caster=caster,_BF=BF):
	if _BF.grid.is_point_solid(target_tile):
		return []
	return _BF.tiles_in_aoe(target_tile, radius,false,true)

	
func callbackOnHit(target):
	target.take_damage(damage)
	target.add_status_effect(slow.new())
