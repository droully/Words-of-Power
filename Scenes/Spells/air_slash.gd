extends Spell

var dir 

func _ready():
	pass # Replace with function body.

func targeting(target_tile):
	dir = BF.get_direction_from_unit_to_tile(caster,target_tile)
	var target_tiles=BF.tiles_in_line(target_tile,dir, srange)
	var targets = []
	for tile in target_tiles:
		targets.append(BF.get_unit_in_tile(tile))
	return targets
	
func effect(target,callback):
	var arg_dict ={"target":target,"dir":dir,"distance":1}
	callback.call("push",arg_dict)
	return arg_dict
