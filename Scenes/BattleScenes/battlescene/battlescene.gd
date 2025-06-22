extends Node2D
class_name BattleScene

@onready var BF : BattleField = $Battlefield
@onready var BM= $BattleManager

var initialized= false

func initialize(_BF: BattleField):
	if self.initialized:
		return
	change_battlefield(_BF)

func _ready():
	pass


func change_battlefield(to_BF:BattleField):

	BF.add_sibling(to_BF)
	BF.queue_free()

	BF = to_BF
	BF.name="Battlefield"
	BM.BF=BF
	
	

func _on_change_bf_pressed():
	
	var to_BF= Utils.get_battlefield_by_name("ocean")
	change_battlefield(to_BF)
