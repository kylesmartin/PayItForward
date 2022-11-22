class_name ATM
extends Fundable

# the tile that the ATM lives on
var current_tile: GridTile

# the ATMs sprite
onready var animated_sprite: AnimatedSprite = get_node("Sprite") as AnimatedSprite


func _process(delta) -> void:
	if current_tile.lower_neighbor == null:
		return
		
	if current_tile.lower_neighbor.occupant != null:
		animated_sprite.play("on")
	else:
		animated_sprite.play("off")


# sets the current tile and occupies it
func set_current_tile(new_tile: GridTile) -> void:
	new_tile.is_atm = true
	new_tile.occupant = self
	current_tile = new_tile
