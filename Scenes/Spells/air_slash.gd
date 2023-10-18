extends Spell

var dir 
func _ready():
	pass # Replace with function body.



func targeteable_tiles(_caster=caster,_BF=BF):
	return _BF.tiles_in_cross(_caster.tile_position,srange)
	

func affected_tiles(target_tile,_caster=caster,_BF=BF):
	dir = _BF.get_direction_from_unit_to_tile(_caster,target_tile)
	var tiles=_BF.tiles_in_line(target_tile,dir, radius)

	return tiles


func animation():
	pass
	
func callbackOnHit(target):
	if  target not in affected_targets:
		target.push( dir,BF)
		target.push( dir,BF)
