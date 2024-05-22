extends Node2D
class_name BattleScene

@onready var BF :BattleField = $Battlefield
@onready var BM= $BattleManager
func _ready():

	pass

func change_battlefield(to_BF:BattleField):
	var player = BM.player
	
	for n in BF.units.get_children():
		BF.units.remove_child(n)
		n.queue_free() 
	
	BF.replace_by(to_BF)


	BF = to_BF
	BF.name="Battlefield"
	#add_child(BF)
	#BF.units.add_child(player)

	
	#Events.emit_signal("battlefield_changed",to_BF)
	

func _on_change_bf_pressed():
	
	var to_BF= Utils.get_battlefield_by_name("ocean")
	change_battlefield(to_BF)


