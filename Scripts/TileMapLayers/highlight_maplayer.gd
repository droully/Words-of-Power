extends BaseMapLayer

class_name HighlightMapLayer

	
func highlight_tiles(tiles,mask_atlas_coord:Vector2i):
	for tile in tiles:		
		if get_cell_source_id(tile) ==-1:
			set_cell(tile,0,mask_atlas_coord)
			
func reset_highlight(tiles: Array = all_tiles()):
	for tile in tiles:
		set_cell(tile)
