class_name Player
extends Fundable

# the player id
var id: int = 1

# the current tile that the player is on
var current_tile: GridTile

# true if current mobile player
var is_active: bool = false

# true if in idle state
var is_idle: bool = true

# the idle node
onready var idle = get_node("StateMachine/Idle")

# the walk node
onready var walk = get_node("StateMachine/Walk")

var is_finished = false

var failed = false

signal out_of_funds()

func finish():
	is_active = false
	is_finished = true
	$Finish.play()
	current_tile.occupant = null


func _process(delta):
	if balance == 0 && is_idle && !is_finished:
		emit_signal("out_of_funds")


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	if current_tile != null:
		current_tile.occupant = null
	new_tile.occupant = self
	current_tile = new_tile


# funds the neighbor in the given direction
func fund_neighbor(direction: String) -> bool:
	var neighbor_to_check: GridTile = current_tile.get_neighbor_from_direction(direction)
	# check if neighbor is fundable
	if neighbor_to_check != null && neighbor_to_check.occupant != null:
		# get occupant or atm
		var recipient: Fundable = neighbor_to_check.occupant as Fundable
		# transfer funds
		transfer_funds(recipient, 1)
		print("Player %d gave one dollar" % id)
		$GiveCoin.play()
		return true

	return false


# checks if player is able to move in given direction (neighbor must exist and be unoccupied)
func check_move(direction: String) -> bool:
	if !is_active or failed:
		return false
	var neighbor_to_check: GridTile = current_tile.get_neighbor_from_direction(direction)
	return neighbor_to_check != null && neighbor_to_check.occupant == null
