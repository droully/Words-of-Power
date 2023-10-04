extends Control

@onready var BM = get_node("../BattleManager")
@onready var BF = get_node("../Battlefield")
@onready var player = get_node("../Battlefield/Player")

@onready var Layer = BF.Layer

var last_highlighted_tile = Vector2i(-1, -1)

func _input(event):
	match BM.user_action_state:
		BM.UserActionState.Move:
			if event is InputEventMouseMotion :
				var tile_position = BF.mouse_to_tile(event.position)
				# Clear the previously highlighted tile (set it to -1 which means no tile)
				BF.set_cell(Layer.Highlight,last_highlighted_tile)
				if BF.tile_inside_BF(tile_position):
					#Set the highlight tile on the desired layer
					BF.set_cell(Layer.Highlight,tile_position,1,Vector2i(0,0)) #Vector2i(0,0): amarillo
					last_highlighted_tile = tile_position
				else:
					last_highlighted_tile = Vector2(-1, -1)  # Reset
		BM.UserActionState.Cast:
			if event is InputEventMouseMotion :
				var tile_position = BF.mouse_to_tile(event.position)
				# Clear the previously highlighted tile (set it to -1 which means no tile)
				BF.set_cell(Layer.Highlight,last_highlighted_tile)
				if BF.tile_inside_BF(tile_position):
					#Set the highlight tile on the desired layer
					BF.set_cell(Layer.Highlight,tile_position,1,Vector2i(1,0)) #Vector2i(1,0): rojo
					last_highlighted_tile = tile_position
				else:
					last_highlighted_tile = Vector2(-1, -1)  # Reset
		_:
			BF.set_cell(Layer.Highlight,last_highlighted_tile)


func _process(_delta):
	match BM.turn_queue[0]:
		BM.player:
			$TurnContainer/EnemyTurnUI.hide()
			$TurnContainer/PlayerTurnUI.show()
	
		BM.enemy:
			$TurnContainer/PlayerTurnUI.hide()
			$TurnContainer/EnemyTurnUI.show()
			
	match BM.user_action_state:
		BM.UserActionState.Move:
			for tile in BF.tiles_in_aoe(player.tile_position,player.speed):
				if BF.get_cell_source_id(Layer.Highlight, tile) !=-1:
					pass
				else:
					BF.set_cell(Layer.Highlight,tile,1,Vector2i(2,0))


		BM.UserActionState.Cast:
			pass #TODO usar señales
		_:
			
			for tiles in BF.all_tiles():
				BF.set_cell(Layer.Highlight,tiles)
func _on_spell_pressed():
	pass
	#player_chose_action = true
#	attack_button.disabled = true

func _on_move_pressed():
	pass
