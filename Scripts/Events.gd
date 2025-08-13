extends Node

signal battle_start()
signal turn_start(unit)

signal player_created(player)

signal win_level()

signal debug()
signal battlefield_changed(bf)

signal spell_button_pressed(spell_name)

signal spell_cast_anim_start(spell,anim)
signal spell_cast_anim_end(spell,anim)

signal spell_effect(arg_dict)


signal command_unit_moved(unit,from_cell,to_cell)
signal command_unit_jumped(unit,from_cell,to_cell)
signal command_spell_casted(caster,spell,target_tile)
signal command_unit_deployed(unit,target_tile)

signal button_pressed(button,tile_position)
signal button_unpressed(button,tile_position)


signal ground_destroyed(ground)

signal ground_move_anim_start(ground,anim)
signal ground_move_anim_end(ground,anim)

signal unit_move_anim_start(unit,anim)
signal unit_move_anim_end(unit,anim)
signal unit_rotate(unit,orientation)
signal unit_set_on_tile(unit,from_tile,to_tile)
signal unit_die(unit)
