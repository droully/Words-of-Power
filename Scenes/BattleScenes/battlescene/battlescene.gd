extends Node2D
class_name BattleScene

@onready var BF :BattleField = $Battlefield
@onready var BM= $BattleManager
func _ready():

	pass

func change_battlefield(to_BF:BattleField):
	var player = BM.player	
	BF.units.remove_child(player)
	BF.free()
	
	to_BF.name="Battlefield"
	add_child(to_BF)
	to_BF.units.add_child(player)


func _on_change_bf_pressed():
	
	var to_BF= Utils.get_battlefield_by_name("ocean")
	change_battlefield(to_BF)
