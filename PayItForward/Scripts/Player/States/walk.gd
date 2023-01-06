extends State

# the walk animation duration
export var walk_animation_duration: float = 1.2

# the animated sprite attached to this state
export var animated_sprite_path = NodePath()
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)

# the player that owns this walk state
export var player_path = NodePath()
onready var player: Player = get_node(player_path)

# the current direction of the walk
var direction

# the tile the player is moving to
var next_tile: GridTile

# the current time in the walk duration
var t = 0

# emitted when this player finishes moving
signal move_completed()


# upon entering the state, we set the animation state to walk with a given direction
func enter(_msg := {}) -> void:
	player.is_idle = false
	# get next tile
	direction = _msg["direction"]
	next_tile = player.current_tile.get_neighbor_from_direction(direction)
	# play animation
	animated_sprite.play("walk_%s" % direction)
	# decrement player balance
	player.remove_funds(1) # TODO: set movement cost as a constant somewhere
	print("Player %d balance is now %d" % [player.id, player.balance]) # TODO: send signal to level manager here


# on exit, stop the current idle animation
func exit() -> void:
	# set player to idle and set change current tile
	player.is_idle = true
	player.set_current_tile(next_tile) 
	# communicate to player that a move has been made
	emit_signal("move_completed")
	# reset time and next tile
	t = 0
	next_tile = null
	# stop animation
	animated_sprite.stop()


# moves the player
func physics_update(_delta: float) -> void:
	# do not proceed if the player or the state is inactive
	if !is_active or !player.is_active:
		return

	# lerp the player position using t
	t += _delta * walk_animation_duration
	player.position = player.current_tile.position.linear_interpolate(next_tile.position, t)

	# transition if destination tile reached
	if player.position == next_tile.position:
		state_machine.transition_to("Idle", {"direction": direction})
