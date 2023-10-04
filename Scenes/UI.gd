extends Control

@onready var HPBar = $HPBar

# Update the health display

func refresh(unit):
	$StatsContainer/AttLabel.text=str(unit.att)
	$StatsContainer/DefLabel.text=str(unit.def)
	HPBar.max_value = unit.max_hp
	HPBar.value = unit.hp
