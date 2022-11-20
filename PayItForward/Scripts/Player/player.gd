class_name Player
extends Fundable

export var id: int

var current_tile: GridTile

var is_active: bool = false


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	if current_tile != null:
		current_tile.occupant = null
	new_tile.occupant = self
	current_tile = new_tile


func fund_neighbor(direction: String) -> bool:
	if direction == "forward" && current_tile.lower_neighbor != null && (current_tile.lower_neighbor.occupant != null or current_tile.lower_neighbor.atm != null):
		var recipient: Fundable = current_tile.lower_neighbor.occupant as Fundable
		if current_tile.lower_neighbor.atm != null:
			recipient = current_tile.lower_neighbor.atm
		transfer_funds(recipient, 1)
		print("Player %d gave one dollar" % id)
		return true
	elif direction == "backward" && current_tile.upper_neighbor != null && (current_tile.upper_neighbor.occupant != null or current_tile.upper_neighbor.atm != null):
		var recipient: Fundable = current_tile.upper_neighbor.occupant as Fundable
		if current_tile.upper_neighbor.atm != null:
			recipient = current_tile.upper_neighbor.atm
		transfer_funds(recipient, 1)
		print("Player %d gave one dollar" % id)
		return true
	elif direction == "left" && current_tile.left_neighbor != null && (current_tile.left_neighbor.occupant != null or current_tile.left_neighbor.atm != null):
		var recipient: Fundable = current_tile.left_neighbor.occupant as Fundable
		if current_tile.left_neighbor.atm != null:
			recipient = current_tile.left_neighbor.atm
		transfer_funds(recipient, 1)
		print("Player %d gave one dollar" % id)
		return true
	elif direction == "right" && current_tile.right_neighbor != null && (current_tile.right_neighbor.occupant != null or current_tile.right_neighbor.atm != null):
		var recipient: Fundable = current_tile.right_neighbor.occupant as Fundable
		if current_tile.right_neighbor.atm != null:
			recipient = current_tile.right_neighbor.atm
		transfer_funds(recipient, 1)
		print("Player %d gave one dollar" % id)
		return true
	return false


# checks if player is able to move in given direction (neighbor must exist and be unoccupied)
func check_move(direction: String) -> bool:
	if !is_active:
		return false
	
	if direction == "forward":
		return current_tile.lower_neighbor != null && current_tile.lower_neighbor.atm == null && current_tile.lower_neighbor.occupant == null
	elif direction == "backward":
		return current_tile.upper_neighbor != null && current_tile.upper_neighbor.atm == null && current_tile.upper_neighbor.occupant == null
	elif direction == "left":
		return current_tile.left_neighbor != null && current_tile.left_neighbor.atm == null && current_tile.left_neighbor.occupant == null
	elif direction == "right":
		return current_tile.right_neighbor != null && current_tile.right_neighbor.atm == null && current_tile.right_neighbor.occupant == null
	else:
		push_error("Error checking neighbor: invalid direction '%s'" % direction)
		return false
