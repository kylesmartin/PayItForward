class_name PlayerBalanceUI
extends Node

# each of the possible player heads
var heads = [
	"res://Sprites/head1.png",
	"res://Sprites/head2.png",
	"res://Sprites/head3.png",
	"res://Sprites/head4.png",
]

onready var current_head: TextureRect = get_node("Background/Head") as TextureRect

onready var balance_label: Label = get_node("Background/Balance") as Label

var player: Player


func _process(delta):
	if player == null:
		return
		
	balance_label.text = "$%d" % player.balance
	

# set_player sets the texture and the balance label
func set_player(_player: Player):
	current_head.texture = load(heads[_player.id-1])
	player = _player
