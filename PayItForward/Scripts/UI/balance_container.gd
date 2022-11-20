class_name BalanceContainerUI
extends MarginContainer

# the balance ui that gets spawned
var balance_ui = preload("res://Scenes/PlayerBalanceUI.tscn")

# the list of balances
onready var balances_list = get_node("HBoxContainer/Balances")


# spawns player balance UIs given a list of players
func spawn_balance_uis(players) -> void:
	for p in players:
		var player: Player = p as Player
		var balance_ui_instance: PlayerBalanceUI = balance_ui.instance() as PlayerBalanceUI
		balances_list.add_child(balance_ui_instance)
		balance_ui_instance.set_player(player)
