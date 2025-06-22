extends Node

@warning_ignore("unused_signal")
signal battle_start()
@warning_ignore("unused_signal")
signal turn_start(unit)

@warning_ignore("unused_signal")
signal player_created(player)

@warning_ignore("unused_signal")
signal debug()
@warning_ignore("unused_signal")
signal battlefield_changed(bf)

@warning_ignore("unused_signal")
signal spell_button_pressed(spell_name)

@warning_ignore("unused_signal")
signal spell_cast_anim_start(spell,anim)
@warning_ignore("unused_signal")
signal spell_cast_anim_end(spell,anim)

@warning_ignore("unused_signal")
signal spell_effect(arg_dict)


@warning_ignore("unused_signal")
signal command_unit_moved(unit,from_cell,to_cell)
@warning_ignore("unused_signal")
signal command_spell_casted(caster,spell,target_tile)
@warning_ignore("unused_signal")
signal command_unit_deployed(unit,target_tile)

@warning_ignore("unused_signal")
signal button_pressed(button,tile_position)
@warning_ignore("unused_signal")
signal button_unpressed(button,tile_position)


@warning_ignore("unused_signal")
signal unit_move_anim_start(unit,anim)
@warning_ignore("unused_signal")
signal unit_move_anim_end(unit,anim)
@warning_ignore("unused_signal")
signal unit_rotate(unit,orientation)
@warning_ignore("unused_signal")
signal unit_set_on_tile(unit,from_tile,to_tile)
@warning_ignore("unused_signal")
signal unit_die(unit)
