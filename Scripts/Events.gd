extends Node

signal battle_start()
signal turn_start(unit)

signal battlefield_changed(BF)

signal spell_button_pressed(spell_name)

signal spell_cast_anim_start(spell)
signal spell_cast_anim_end(spell)

signal spell_effect(arg_dict)

signal unit_moved_global_coord(unit,from_coord,to_coord)

signal command_unit_moved(unit,from_cell,to_cell)
signal command_spell_casted(caster,spell,target_tile)
signal command_unit_deployed(unit,target_tile)

signal unit_move_anim_start(unit)
signal unit_move_anim_end(unit)

signal unit_die(unit)
