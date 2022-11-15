tool
extends Node

# the walkable grid tile
var grid_tile = preload("res://Scenes/GridTile.tscn")

# the player scene
var player = preload("res://Scenes/Player.tscn")

# the size of the square grid tile in pixels
var grid_size = 16

"""
stores the format of the grid

0 = null space
1 = walkable space
2 = ATM
3 = player spawn
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
	var tiles = []
	var players = []

	# delete existing children
	for n in get_children():
		n.queue_free()

	# spawn new grid tiles
	var current_pos = Vector2.ZERO
	for i in len(grid):

		var tile_row = []
		for j in len(grid[i]):
			
			var tile_instance: GridTile
			# create walkable space
			if grid[i][j] == 1 or grid[i][j] == 3:
				tile_instance = grid_tile.instance()
				tile_instance.position = current_pos
				add_child(tile_instance)
				tile_row.push_back(tile_instance)
			# create atm
			elif grid[i][j] == 2:
				# TODO
				print("TODO: Spawn ATM")
				tile_row.push_back(null)
			else:
				tile_row.push_back(null)

			# spawn player
			if grid[i][j] == 3:
				var player_instance: Player = player.instance()
				player_instance.position = current_pos
				add_child(player_instance)
				# store player instance and current tile instance
				player_instance.current_tile = tile_instance
				players.push_back(player)

			# increment x position
			current_pos = Vector2(current_pos.x + grid_size, current_pos.y)

		# append tile row
		tiles.push_back(tile_row)
		# increment y position, set x position to 0
		current_pos = Vector2(0, current_pos.y + grid_size)
	
	# find neighbors of each grid tile
	for i in len(tiles):
		for j in len(tiles[i]):
			if tiles[i][j] == null:
				continue
			tiles[i][j].find_neighbors(tiles, i, j)
