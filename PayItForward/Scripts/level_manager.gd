class_name LevelManager
extends Node

var players = []

var current_index: int = 0


func _process(delta: float) -> void:

	var current_player: Player = players[current_index]
	
	if Input.is_action_just_released("scroll_up"):
		current_player.is_active = false
		current_index += 1
		if current_index == len(players):
			current_index = 0
		current_player = players[current_index]

	elif Input.is_action_just_released("scroll_down"):
		current_player.is_active = false
		current_index -= 1
		if current_index < 0:
			current_index = len(players) - 1
		current_player = players[current_index]
	
	current_player.is_active = true
