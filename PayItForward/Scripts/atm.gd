class_name ATM
extends Fundable

var current_tile: GridTile


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	new_tile.atm = self
	current_tile = new_tile
