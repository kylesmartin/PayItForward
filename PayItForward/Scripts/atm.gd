class_name ATM
extends Fundable

var current_tile: GridTile

export var animated_sprite_path = NodePath()

onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)


func _process(delta) -> void:
	if current_tile.lower_neighbor == null:
		return
		
	if current_tile.lower_neighbor.occupant != null:
		animated_sprite.play("on")
	else:
		animated_sprite.play("off")


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	new_tile.atm = self
	current_tile = new_tile
