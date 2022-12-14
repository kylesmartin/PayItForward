tool
extends Node

# the level manager scene
var level_manager = preload("res://Scenes/LevelManager.tscn")

export var level_id: int = 1

# walkable grid tiles
var grid_tile = preload("res://Scenes/GridTile.tscn")
# var tax_2 = preload("res://Scenes/Tax2.tscn")
# var tax_3 = preload("res://Scenes/Tax3.tscn")
# var tax_4 = preload("res://Scenes/Tax4.tscn")
# var tax_5 = preload("res://Scenes/Tax5.tscn")

var player_prefab = preload("res://Scenes/Player.tscn")

# the atm scene
# var atm = preload("res://Scenes/ATM.tscn")

# the size of the square grid tile in pixels
var grid_size = 16

# the grid of GridTiles
var tiles = []

# the grid of Players
var players = []

# the grid of ATMs
# var atms = []

# list of all nodes spawned by the grid generator
var spawned_nodes = []

var max_players = 4

# the player balance container
# onready var balance_container: BalanceContainerUI = get_node("CanvasLayer/BalanceContainer")

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

# x, y
export var player_finishes = [
	Vector2(0, 0)
]


func _ready() -> void:
	# add level manager to game
	var level_manager_instance: LevelManager = level_manager.instance() as LevelManager
	add_child(level_manager_instance)
	level_manager_instance.level_id = level_id
	
	# find neighbors of each grid tile
	for i in len(tiles):
		for j in len(tiles[i]):
			# skip if null
			if tiles[i][j] == null:
				continue
			var tile: GridTile = tiles[i][j] as GridTile
			tile.find_neighbors(tiles, i, j)
			level_manager_instance.grid_tiles.push_back(tile)

	# set current tiles of all players
	var player_list = []
	var id = 1
	for i in len(players):
		for j in len(players[i]):
			# skip if null
			if players[i][j] == null:
				continue
			var start_tile: GridTile = tiles[i][j] as GridTile
			var p: Player = players[i][j] as Player
			p.id = id
			id += 1
			p.set_current_tile(start_tile)
			# add player to player list in level manager
			player_list.push_back(p)
	level_manager_instance.set_players(player_list)

	"""
	# set current tiles of all atms
	for i in len(atms):
		for j in len(atms[i]):
			# skip if null
			if atms[i][j] == null:
				continue
			var atm: ATM = atms[i][j] as ATM
			atm.set_current_tile(tiles[i][j] as GridTile)
	"""

	# fund players
	for player_start in player_starts:
		# player_start contains start coordinates and funds
		var x: int = player_start.x
		var y: int = player_start.y
		var funds: int = player_start.z
		# fund each Fundable component
		var p: Fundable = players[x][y]
		if p == null:
			push_error("grid_generator._ready: no player found at (%d, %d)" % [x, y])
			return
		p.balance = funds

	# convert tiles to finishing tiles
	for i in len(player_finishes):
		# get coordinates
		var x: int = player_finishes[i].x
		var y: int = player_finishes[i].y
		# set associated player id of tile
		var finish_tile: GridTile = tiles[x][y] as GridTile
		finish_tile.set_player_id(i+1, true)
	
	# handle first move on all tiles
	level_manager_instance.increment_move()


# updates the grid upon changes in the editor
func set_grid(new_grid):
	var player_count: int = 0
	grid = new_grid
	tiles = []
	players = []
	# atms = []

	# delete existing children
	for n in spawned_nodes:
		remove_child(n)
		n.queue_free()
		
	spawned_nodes.clear()

	# spawn new grid tiles
	var current_pos = Vector2.ZERO
	for i in len(grid):

		var tile_row: Array = []
		var player_row: Array = []
		var atm_row: Array = []
		for j in len(grid[i]):

			# create regular space
			if grid[i][j] == 1 || grid[i][j] == 2 || grid[i][j] == 3:
				spawn_grid_object(grid_tile, current_pos, tile_row)
				"""
				elif grid[i][j] == 4:
					spawn_grid_object(tax_2, current_pos, tile_row)
				elif grid[i][j] == 5:
					spawn_grid_object(tax_3, current_pos, tile_row)
				elif grid[i][j] == 6:
					spawn_grid_object(tax_4, current_pos, tile_row)
				elif grid[i][j] == 7:
					spawn_grid_object(tax_5, current_pos, tile_row)
				"""
			else:
				tile_row.push_back(null)

			"""
			# create atm
			if grid[i][j] == 2:
				spawn_grid_object(atm, current_pos, atm_row)
			else:
				atm_row.push_back(null)
			"""

			# spawn player
			if grid[i][j] == 3:
				if player_count == max_players:
					push_error("grid_generator.set_grid: too many players")
					return;
				spawn_grid_object(player_prefab, current_pos, player_row)
				player_count += 1
			else:
				player_row.push_back(null)

			# increment x position
			current_pos = Vector2(current_pos.x + grid_size, current_pos.y)

		# append rows
		tiles.push_back(tile_row)
		players.push_back(player_row)
		# atms.push_back(atm_row)
		# increment y position, set x position to 0
		current_pos = Vector2(0, current_pos.y + grid_size)


# spawns a grid object and sets its position
func spawn_grid_object(node, position: Vector2, row: Array) -> void:
	var node_instance = node.instance()
	node_instance.position = position
	add_child(node_instance)
	row.push_back(node_instance)
	spawned_nodes.push_back(node_instance)
