extends State

export var animated_sprite_path = NodePath()

export var walk_animation_duration: float = 1.2

onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)

export var player_path = NodePath()

onready var player: Player = get_node(player_path)

var direction

var next_tile: GridTile

# the time to walk from one tile to another
var t = 0


# Upon entering the state, we set the animation state to walk with a given direction
func enter(_msg := {}) -> void:
	player.is_idle = false
	
	direction = _msg["direction"]
	# get next tile
	if direction == "forward":
		next_tile = player.current_tile.lower_neighbor
	elif direction == "backward":
		next_tile = player.current_tile.upper_neighbor
	elif direction == "left":
		next_tile = player.current_tile.left_neighbor
	elif direction == "right":
		next_tile = player.current_tile.right_neighbor
	# play animation
	animated_sprite.play("walk_%s" % direction)
	# decrement player balance
	player.remove_funds(1) # TODO: set movement cost as a constant somewhere
	print("Player %d balance is now %d" % [player.id, player.balance]) # TODO: send signal here


# On exit, stop the current idle animation
func exit() -> void:
	player.is_idle = true
	
	player.set_current_tile(next_tile)
	t = 0
	next_tile = null
	animated_sprite.stop()


# moves the player
func physics_update(_delta: float) -> void:
	if !is_active or !player.is_active:
		return

	# lerp the player position using t
	t += _delta * walk_animation_duration
	player.position = player.current_tile.position.linear_interpolate(next_tile.position, t)
	
	# transition if destination tile reached
	if player.position == next_tile.position:
		state_machine.transition_to("Idle", {"direction": direction})
