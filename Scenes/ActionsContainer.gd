extends VBoxContainer
signal spell_button_pressed(spell_name)

var spells_UI = ["Base Spell","Fire Ball","Air Slash"]
var spells_Name = ["base_spell","fire_ball","air_slash"]

func _ready():
 # Replace with the actual path to your VBoxContainer.
	

	# Create new buttons.
	for i in range(len(spells_UI)):
		var button = Button.new()
		button.text = spells_UI[i] 
		
		add_child(button)
	# Add your logic here to cast the spell or whatever you'd like to do.
		button.pressed.connect(_on_spell_button_pressed.bind(spells_Name[i]))

func _on_spell_button_pressed(spell_name):
	emit_signal("spell_button_pressed",spell_name)
