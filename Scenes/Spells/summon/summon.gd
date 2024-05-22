extends Spell


func _ready():
	pass

func _process(_delta):
	pass
	

func targetable_tiles(_caster=caster,_BF=BF):
	return _BF.tiles_in_aoe(_caster.tile_position,srange,false,true)
	
func affected_tiles(target_tile,_caster=caster,_BF=BF):
	if _BF.is_tile_solid(target_tile):
		return []
	return _BF.tiles_in_aoe(target_tile, radius,false,true)

func callbackOnFloor(BF,tile):
	BF.summon(tile,"unit")

