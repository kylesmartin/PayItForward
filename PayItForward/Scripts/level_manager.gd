class_name LevelManager
extends Node

var players = []

var current_index: int = 0

var finished_players = 0


func set_players(_players):
	players = _players
	for player in players:
		player.idle.connect("player_finished", self, "_on_player_finished")


func _process(delta: float) -> void:
	if finished_players == len(players):
		return

	var current_player: Player = players[current_index]

	if Input.is_action_just_pressed("space") and current_player.is_idle:
		current_player.is_active = false
		current_index += 1
		if current_index == len(players):
			current_index = 0
		while players[current_index] == null:
			current_index += 1
			if current_index == len(players):
				current_index = 0
		current_player = players[current_index]

	current_player.is_active = true


func _on_player_finished():
	print("Player %d finished" % (current_index + 1))
	finished_players += 1
	# set finished player
	var finished_player: Player = players[current_index] as Player
	finished_player.is_finished = true
	finished_player.is_active = false
	players[current_index] = null
	# check for game over condition
	if finished_players == len(players):
		print("GAME OVER: TODO switch to next level")
		return
	# go to next player
	current_index += 1
	if current_index == len(players):
		current_index = 0
	while players[current_index] == null:
		current_index += 1
	if current_index == len(players):
		current_index = 0
		if current_index == len(players):
			current_index = 0
	var current_player: Player = players[current_index]
	current_player.is_active = true
