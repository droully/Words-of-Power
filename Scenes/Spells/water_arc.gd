extends Spell

@onready var anim_player= $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass
	

func targeteable_tiles(_caster=caster,_BF=BF):
	return _BF.tiles_in_cross(_caster.tile_position,srange)

func affected_tiles(target_tile,_caster=caster,_BF=BF):
	var dir = _BF.get_direction_from_unit_to_tile(_caster,target_tile)
	var tiles=_BF.tiles_perpendicular(target_tile,dir, radius)

	return tiles

func animation():
	pass


	
func callbackOnHit(target):
	if target.take_damage(damage):
		caster.increase_shield()
#	target.add_status_effect(burning_effect.new())
