extends Node
@onready var unit= get_parent()

func execute_turn(BM, BF):
	var player_tile = BM.player.tile_position  
	var unit_tile = unit.tile_position  
	
	
	var spell=Utils.get_spell_by_name("fire_ball")
	
	for tile in spell.targetable_tiles(unit,BF):
		if BF.get_unit_in_tile(tile) == BM.player:  # identifies player
			var castCommand = Command.Cast.new(unit,spell,tile, BF,false)
			return  castCommand

	var distance_to_player=BF.distance(unit_tile, player_tile)
	var best_tile=unit.tile_position
	for tile in unit.walkable_tiles(BF):

		if BF.distance(tile, player_tile)<distance_to_player:
			distance_to_player=BF.distance(tile, player_tile)
			best_tile=tile
			var moveCommand = Command.Move.new(unit, best_tile, BF)
			return moveCommand






















#
#func execute_turn(BM, BF):
	#var player_tile = BM.player.tile_position  
	#var _unit_tile = unit.tile_position  
	#var spell=Utils.get_spell_by_name("fire_ball")
	#
	#var best_command
	#var best_score=-1000
	#var l = []
	#
	#for tile in spell.targetable_tiles(unit,BF):
		#var BF2 = BF.duplicate()
		#var BM2 = duplicate_object(BM)
		#
		#BF2.BM=BM2
		#BF2.set_grid()
		#
		#var unit2=BF2.get_node(NodePath(unit.get_name()))
		#
		## unit debe ser el child de BF2, no de BF
		#var castCommand = Command.Cast.new(unit,spell,tile, BF2,true)
		#BM2.setCommand(castCommand)
		#BM2.executeCommand()
		#l.append( evaluate(BF2,BM2))
		#print(l)
		#
		#
	#var distance_to_player=1000
	#var best_tile=unit.tile_position
	#for tile in unit.walkable_tiles(BF):
		#if BF.distance(tile, player_tile)<distance_to_player:
			#distance_to_player=BF.distance(tile, player_tile)
			#best_tile=tile
	#var moveCommand = Command.Move.new(unit, best_tile, BF)
	#return moveCommand
#
#func duplicate_object(OBJ):
	#var OBJ2 = OBJ.duplicate()
	#var l=OBJ.get_property_list()
	#for property in l:
		#if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#if is_instance_valid(OBJ.get(property.name)):
				#var prop=OBJ.get(property.name)
				#if prop is Node or prop is Resource:
					#OBJ2.set(property.name, prop.duplicate())
				#else :
					#OBJ2.set(property.name, prop)
	#return OBJ2
	#
#func evaluate(BF,BM2):
	#
	#var player=BM2.player
	#
	#var player_hp=player.hp
	#var unit_hp=unit.hp
	#var distance_to_player = BF.distance(unit.tile_position  , player.tile_position)
	#
	#var score= unit_hp-player_hp-distance_to_player
