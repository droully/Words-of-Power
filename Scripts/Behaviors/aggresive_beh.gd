extends Node

func choose_command(BF):
	var unit= get_parent() 
	var player_tile = BF.player.tile_position  
	var unit_tile = unit.tile_position  
	
	var targeting = Targeting.new()
	
	var spell_to_cast=Utils.get_spell_data_by_name("fire_ball")

	for tile in targeting.targetable_tiles(unit, spell_to_cast, BF):
		if BF.map.get_unit_in_tile(tile) == BF.player:  # identifies player
			var castCommand = Command.Cast.new(unit,spell_to_cast,tile, BF,false)
			return  castCommand

	var distance_to_player=BF.distance(unit_tile, player_tile)
	var best_tile=unit.tile_position
	for tile in unit.walkable_tiles():

		if BF.distance(tile, player_tile)<distance_to_player:
			distance_to_player=BF.distance(tile, player_tile)
			best_tile=tile
			var moveCommand = Command.Move.new(unit, best_tile, BF)
			return moveCommand

func callbackUnitOverlap(unit_on_top):
	pass
