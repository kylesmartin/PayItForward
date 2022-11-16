tool
extends Node

# the walkable grid tile
var grid_tile = preload("res://Scenes/GridTile.tscn")

# the player scene
var player = preload("res://Scenes/Player.tscn")

# the atm scene
var atm = preload("res://Scenes/ATM.tscn")

# the size of the square grid tile in pixels
var grid_size = 16

# the grid of GridTiles
var tiles = []

# the grid of Players
var players = []

# the grid of ATMs
var atms = []

# the path to the node that will own grid spawns
export var owner_path = NodePath()

# the owner of the grid spawns
onready var grid_owner = get_node(owner_path)


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


func _ready() -> void:
	# find neighbors of each grid tile
	for i in len(tiles):
		for j in len(tiles[i]):
			# skip if null
			if tiles[i][j] == null:
				continue
			var tile: GridTile = tiles[i][j] as GridTile
			tile.find_neighbors(tiles, i, j)

	# set current tiles of all players
	for i in len(players):
		for j in len(players[i]):
			# skip if null
			if players[i][j] == null:
				continue
			var p: Player = players[i][j] as Player
			p.set_current_tile(tiles[i][j] as GridTile)

	# set current tiles of all atms
	for i in len(atms):
		for j in len(atms[i]):
			# skip if null
			if atms[i][j] == null:
				continue
			var atm: ATM = atms[i][j] as ATM
			atm.set_current_tile(tiles[i][j] as GridTile)
	

# updates the grid
func set_grid(new_grid):
	grid = new_grid
	tiles = []
	players = []
	atms = []
	

	# delete existing children
	for n in get_children():
		remove_child(n)
		n.queue_free()

	# spawn new grid tiles
	var current_pos = Vector2.ZERO
	for i in len(grid):

		var tile_row = []
		var player_row = []
		var atm_row = []
		for j in len(grid[i]):

			# create walkable space
			if grid[i][j] > 0:
				var tile_instance = grid_tile.instance()
				tile_instance.position = current_pos
				add_child(tile_instance)
				tile_row.push_back(tile_instance)
			else:
				tile_row.push_back(null)

			# create atm
			if grid[i][j] == 2:
				var atm_instance = atm.instance()
				atm_instance.position = current_pos
				add_child(atm_instance)
				# atm_instance.owner = grid_owner # should be editable in lvl editor
				atm_row.push_back(atm_instance)
			else:
				atm_row.push_back(null)

			# spawn player
			if grid[i][j] == 3:
				var player_instance = player.instance()
				player_instance.position = current_pos
				add_child(player_instance)
				# player_instance.owner = grid_owner # should be editable in lvl editor
				player_row.push_back(player_instance)
			else:
				player_row.push_back(null)

			# increment x position
			current_pos = Vector2(current_pos.x + grid_size, current_pos.y)

		# append rows
		tiles.push_back(tile_row)
		players.push_back(player_row)
		atms.push_back(atm_row)
		# increment y position, set x position to 0
		current_pos = Vector2(0, current_pos.y + grid_size)
