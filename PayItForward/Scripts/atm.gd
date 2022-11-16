class_name ATM
extends Node

var current_tile: GridTile


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	new_tile.is_occupied = true
	current_tile = new_tile