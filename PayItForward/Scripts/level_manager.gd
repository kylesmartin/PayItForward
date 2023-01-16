class_name LevelManager
extends Node

# the array of players in the game
var players = []

# the array of grid tiles in the game
var grid_tiles = []

# the current player's index
var current_index: int = 0

# the number of players that have finished
var finished_players = 0

# the current move id
var current_move = -1

var level_id = 0


# sets the players and connects to their finished signals
func set_players(_players) -> void:
	players = _players
	for player in players:
		player.idle.connect("player_finished", self, "_on_player_finished")
		player.walk.connect("move_completed", self, "increment_move")
		player.connect("out_of_funds", self, "reset_level")


func _process(delta: float) -> void:
	# if the level is finished, there is no need for processing
	if finished_players == len(players):
		return

	# get current player
	var current_player: Player = players[current_index]

	if Input.is_action_just_pressed("space") and current_player.is_idle:
		current_player.is_active = false
		loop_increment()
		while players[current_index] == null:
			loop_increment()
		current_player = players[current_index]

	# set current player to active
	current_player.is_active = true


func reset_level():
	for player in players:
		if player == null:
			continue
		player.is_active = false
		player.failed = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/Levels/Level%d.tscn" % level_id)


func to_next_level():
	yield(get_tree().create_timer(1.0), "timeout")
	if level_id == 12:
		get_tree().change_scene("res://Scenes/Menu.tscn")
	else:
		get_tree().change_scene("res://Scenes/Levels/Level%d.tscn" % (level_id + 1))


# runs when a player finishes the level
func _on_player_finished():
	# increment finished players
	print("Player %d finished" % (current_index + 1))
	finished_players += 1
	# set current player to finished
	var finished_player: Player = players[current_index] as Player
	finished_player.finish()
	players[current_index] = null
	# check for level complete condition
	if finished_players == len(players):
		print("Level completed! Switching to next level (TODO)")
		to_next_level()
		return
	# go to next player
	loop_increment()
	while players[current_index] == null:
		loop_increment()
	# set new current player to active
	var current_player: Player = players[current_index]
	current_player.is_active = true


# increments the current_index, looping back to 0
func loop_increment():
	current_index += 1
	if current_index == len(players):
		current_index = 0


func increment_move() -> void:
	current_move += 1
	# check the tax of each tile
	for elem in grid_tiles:
		var tile: GridTile = elem as GridTile
		tile.handle_current_move(current_move)
