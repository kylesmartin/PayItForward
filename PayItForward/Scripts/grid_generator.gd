tool
extends Node

# the level manager scene
var level_manager = preload("res://Scenes/LevelManager.tscn")

# the walkable grid tile
var grid_tile = preload("res://Scenes/GridTile.tscn")

# the four player prefabs
var player_prefabs = [
	preload("res://Scenes/Player1.tscn"),
	preload("res://Scenes/Player2.tscn"),
	# preload("res://Scenes/Player3.tscn"), // TODO: not ready yet
	# preload("res://Scenes/Player4.tscn")  // TODO: not ready yet
]

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

# list of all nodes spawned by the grid generator
var spawned_nodes = []

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

# x, y, start funds
export var player_starts = [
	Vector3(0, 0, 0)
]

# x, y, player_starts index
export var player_finishes = [
	Vector3(0, 0, 0)
]


func _ready() -> void:
	var level_manager_instance: LevelManager = level_manager.instance() as LevelManager
	add_child(level_manager_instance)
	
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
			var start_tile: GridTile = tiles[i][j] as GridTile
			var p: Player = players[i][j] as Player
			p.set_current_tile(start_tile)
			start_tile.set_player_id(p.id, false)
			level_manager_instance.players.push_back(p)

	# set current tiles of all atms
	for i in len(atms):
		for j in len(atms[i]):
			# skip if null
			if atms[i][j] == null:
				continue
			var atm: ATM = atms[i][j] as ATM
			atm.set_current_tile(tiles[i][j] as GridTile)
			
	# fund players
	for player_start in player_starts:
		var x: int = player_start.x
		var y: int = player_start.y
		var funds: int = player_start.z
		var p: Fundable = players[x][y]
		if p == null:
			push_error("grid_generator._ready: no player found at (%d, %d)" % [x, y])
			return
		p.add_funds(funds)

# updates the grid
func set_grid(new_grid):
	var player_count: int = 0
	grid = new_grid
	tiles = []
	players = []
	atms = []

	# delete existing children
	for n in spawned_nodes:
		remove_child(n)
		n.queue_free()
		
	spawned_nodes.clear()

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
				spawned_nodes.push_back(tile_instance)
			else:
				tile_row.push_back(null)

			# create atm
			if grid[i][j] == 2:
				var atm_instance = atm.instance()
				atm_instance.position = current_pos
				add_child(atm_instance)
				atm_row.push_back(atm_instance)
				spawned_nodes.push_back(atm_instance)
			else:
				atm_row.push_back(null)

			# spawn player
			if grid[i][j] == 3:
				if player_count == len(player_prefabs):
					push_error("grid_generator.set_grid: too many players")
					return;
				var player_instance = player_prefabs[player_count].instance()
				player_instance.position = current_pos
				add_child(player_instance)
				player_row.push_back(player_instance)
				spawned_nodes.push_back(player_instance)
				player_count += 1
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
