class_name Player
extends Node

var current_tile: GridTile


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	if current_tile != null:
		current_tile.is_occupied = false
	new_tile.is_occupied = true
	current_tile = new_tile


# checks if player is able to move in given direction (neighbor must exist and be unoccupied)
func check_move(direction: String) -> bool:
	if direction == "forward":
		return current_tile.lower_neighbor != null && !current_tile.lower_neighbor.is_occupied
	elif direction == "backward":
		return current_tile.upper_neighbor != null && !current_tile.upper_neighbor.is_occupied
	elif direction == "left":
		return current_tile.left_neighbor != null && !current_tile.left_neighbor.is_occupied
	elif direction == "right":
		return current_tile.right_neighbor != null && !current_tile.right_neighbor.is_occupied
	else:
		push_error("Error checking neighbor: invalid direction '%s'" % direction)
		return false
