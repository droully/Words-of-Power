extends Node
@onready var unit= get_parent()

func execute_turn(BM, BF):
	var player_tile = BM.player.tile_position  
	var unit_tile = unit.tile_position  

	var distance_to_player = BF.distance(unit_tile, player_tile)

	if distance_to_player <= 1:
		for tile in BF.tiles_in_aoe(unit_tile, true):
			if BF.get_unit_in_tile(tile) == BM.player:  # identifies player
				var  order = {"action":"cast","spell":"fire_ball","target":tile}
				return  order

	if distance_to_player > 1:
		# Calculate the tile to move to. This is a simplified example.
		# You could add more logic to choose the best tile to move to.
		var move_tile = unit_tile
		if player_tile.x > unit_tile.x:
			move_tile.x += 1
		elif player_tile.x < unit_tile.x:
			move_tile.x -= 1
		elif player_tile.y > unit_tile.y:
			move_tile.y += 1
		elif player_tile.y < unit_tile.y:
			move_tile.y -= 1

		# Execute the 
		var  order = {"action":"move","unit":unit,"move_tile":move_tile}
		return order
