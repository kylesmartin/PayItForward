extends Node
class_name Player

var current_tile: GridTile


func check_move(direction: String) -> bool:
	if direction == "forward":
		return current_tile.lower_neighbor != null
	elif direction == "backward":
		return current_tile.upper_neighbor != null
	elif direction == "left":
		return current_tile.left_neighbor != null
	elif direction == "right":
		return current_tile.right_neighbor != null
	else:
		push_error("Error checking neighbor: invalid direction '%s'" % direction)
		return false
