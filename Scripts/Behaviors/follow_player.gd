extends Node


func choose_command(BM:BattleManager):
	var unit:Unit= get_parent() 
	var n = BM.player_command_list.size()
	for i in n:
		if i==0:
			continue
		var command = BM.player_command_list[-i-1] #recorrer desde el final
		if command.command_name in ["Move","Jump"]:
			command.unit = unit
			return command
	return Command.Skip.new(unit)
