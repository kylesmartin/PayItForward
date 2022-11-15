extends Node
class_name GridTile

var upper_neighbor: GridTile = null

var lower_neighbor: GridTile = null

var left_neighbor: GridTile = null

var right_neighbor: GridTile = null

var is_atm: bool = false


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
