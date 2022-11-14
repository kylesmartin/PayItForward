tool
extends Node

# the walkable grid tile
var grid_tile = preload("res://Scenes/GridTile.tscn")

# the size of the square grid tile in pixels
var grid_size = 16


"""
stores the format of the grid

0 = null space
1 = walkable space
2 = ATM
"""
export var grid = [
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
] setget set_grid


# updates the grid
func set_grid(new_grid):
	grid = new_grid
	# delete existing children
	for n in get_children():
		remove_child(n)
		n.queue_free()
	# spawn new grid tiles
	var current_pos = Vector2.ZERO
	for i in len(grid):
		for j in len(grid[i]):
			# create walkable space
			if grid[i][j] == 1:
				var tile_instance = grid_tile.instance()
				tile_instance.position = current_pos
				add_child(tile_instance)
				tile_instance.owner = self
			# create atm
			elif grid[i][j] == 2:
				# TODO
				print("TODO: Spawn ATM")
			# increment x position
			current_pos = Vector2(current_pos.x + grid_size, current_pos.y)
		# increment y position, set x position to 0
		current_pos = Vector2(0, current_pos.y + grid_size)
