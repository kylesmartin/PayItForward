class_name LevelManager
extends Node

# the array of players in the game
var players = []

# the current player's index
var current_index: int = 0

# the number of players that have finished
var finished_players = 0


# sets the players and connects to their finished signals
func set_players(_players) -> void:
	players = _players
	for player in players:
		player.idle.connect("player_finished", self, "_on_player_finished")


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


# runs when a player finishes the level
func _on_player_finished():
	# increment finished players
	print("Player %d finished" % (current_index + 1))
	finished_players += 1
	# set current player to finished
	var finished_player: Player = players[current_index] as Player
	finished_player.is_active = false
	players[current_index] = null
	# check for level complete condition
	if finished_players == len(players):
		print("Level completed! Switching to next level (TODO)")
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
