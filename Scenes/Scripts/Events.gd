extends Node

signal spell_button_pressed(spell_name)

signal spell_cast_anim_start(spell)
signal spell_cast_anim_end(spell)

signal spell_effect(arg_dict)

signal unit_moved(unit,from_coord,to_coord)
signal unit_move_anim_start(unit)
signal unit_move_anim_end(unit)
