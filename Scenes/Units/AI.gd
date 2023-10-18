extends Node
@onready var unit= get_parent()

func execute_turn(BM, BF):
	var player_tile = BM.player.tile_position  
	var unit_tile = unit.tile_position  
	
	
	var spell=Utils.get_spell_by_name("fire_ball")
	
	for tile in spell.targeteable_tiles(unit,BF):
		if BF.get_unit_in_tile(tile) == BM.player:  # identifies player
			var castCommand = CastCommand.new(BM.player,spell,tile, BF)
			return  castCommand

	var distance_to_player=1000
	var best_tile=unit.tile_position
	for tile in unit.walkable_tiles(BF):
		if BF.distance(tile, player_tile)<distance_to_player:
			distance_to_player=BF.distance(tile, player_tile)
			best_tile=tile
	var moveCommand = MoveCommand.new(unit, best_tile, BF)
	return moveCommand



