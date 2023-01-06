class_name GridTile
extends Node

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite") as AnimatedSprite

var upper_neighbor: GridTile = null

var lower_neighbor: GridTile = null

var left_neighbor: GridTile = null

var right_neighbor: GridTile = null

var is_finish: bool = false

var player_id: int = 0

var is_atm: bool = false

var occupant: Fundable = null

enum Multiple {ZERO = 0, TWO = 2, THREE = 3, FOUR = 4, FIVE = 5}
export (Multiple) var tax_multiple

onready var state_machine = get_node("StateMachine")


func _ready() -> void:
	set_player_id(0, false)


# given a grid, finds neighbors
func find_neighbors(grid, row: int, column: int):
	# get upper neighbor
	if row > 0:
		upper_neighbor = grid[row - 1][column]
	# get lower neighbor
	if row < len(grid) - 1:
		lower_neighbor = grid[row + 1][column]
	# get left neighbor
	if column > 0:
		left_neighbor = grid[row][column - 1]
	# get right neighbor
	if column < len(grid[row]) - 1:
		right_neighbor = grid[row][column + 1]


func set_player_id(_player_id: int, _is_finish: bool) -> void:
	player_id = _player_id
	is_finish = _is_finish
	animated_sprite.play("space_%d" % player_id)


# get neighbor based on direction
func get_neighbor_from_direction(direction: String) -> GridTile:
	var neighbor: GridTile
	if direction == "forward":
		neighbor = lower_neighbor
	elif direction == "backward":
		neighbor = upper_neighbor
	elif direction == "left":
		neighbor = left_neighbor
	elif direction == "right":
		neighbor = right_neighbor
	else:
		push_error("grid_tile.get_neighbor_from_direction: invalid direction supplied (%s)" % direction)
		return null
	return neighbor


# updates the current tax state based on current move number
func tax_current_move(current_move: int) -> void:
	# don't switch if there is no tax multiple
	if tax_multiple == 0:
		return

	if (current_move / tax_multiple) * tax_multiple == current_move:
		state_machine.transition_to("Tax", {"multiple": tax_multiple})
		# remove funds from occupant
		if occupant != null:
			occupant.remove_funds(5)
	else:
		state_machine.transition_to("Wait", {})
