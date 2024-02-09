extends Control

@onready var unit= get_parent()
@onready var status_effects= unit.get_node("StatusEffects")

@onready var HPBar = $HPBar
@onready var status_container= $StatusContainer

# Update the health display

func refresh():
	if unit.shield > 0:
		if not status_container.has_node("ShieldIcon"): # Check if shield node already exists
			var shield_node = TextureRect.new()
			shield_node.name = "ShieldIcon" # Assign unique name
			shield_node.texture = preload("res://Resources/UI/shield.png")
			status_container.add_child(shield_node)
	else:
		if status_container.has_node("ShieldIcon"):
			status_container.get_node("ShieldIcon").queue_free() # Remove the shield node


	
	if status_effects.has_node("burning"):
		if not status_container.has_node("BurningIcon"): # Check if shield node already exists
			var burning_node = TextureRect.new()
			burning_node.name = "BurningIcon" # Assign unique name
			burning_node.texture = preload("res://Resources/UI/fire.png")
			status_container.add_child(burning_node)
	else:
		if status_container.has_node("BurningIcon"):
			status_container.get_node("BurningIcon").queue_free()
	HPBar.max_value = unit.max_hp
	HPBar.value = unit.hp
