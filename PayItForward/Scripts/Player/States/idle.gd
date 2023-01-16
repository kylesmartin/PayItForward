extends State

# the animated player sprite
export var animated_sprite_path = NodePath()
onready var animated_sprite_node: Node = get_node(animated_sprite_path)
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path) as AnimatedSprite

# the player component associated with this state
export var player_path = NodePath()
onready var player: Player = get_node(player_path) as Player

# emitted when this player finishes
signal player_finished()


# Upon entering the state, we set the animation state to idle with a given direction
func enter(_msg := {}) -> void:
	# player sprite should be 90% size while idle on id-less tile
	if player.current_tile == null or player.current_tile.player_id == 0:
		animated_sprite_node.scale.x = 0.9
		animated_sprite_node.scale.y = 0.9
		animated_sprite_node.position.y = -14.5
	
	# if no message provided, default to forward
	if !_msg.has("direction"):
		print("No direction provided to idle state, defaulting to forward")
		animated_sprite.play("idle_forward")
		return

	# loop idle animation
	animated_sprite.play("idle_%s" % _msg["direction"])
	
	# check if finishing tile
	if player.current_tile.is_finish and player.current_tile.player_id == player.id:
		emit_signal("player_finished")


func update(delta: float) -> void:
	# return if the state or player is inactive
	if !is_active or !player.is_active or player.failed:
		return

	# retrieve funds from atm
	if Input.is_action_just_pressed("interact") and player.current_tile.upper_neighbor != null and player.current_tile.upper_neighbor.is_atm:
		player.current_tile.upper_neighbor.occupant.transfer_funds(player, 1)

	# get direction
	var direction: String
	if Input.is_action_just_pressed("move_up"):
		direction = "backward"
	elif Input.is_action_just_pressed("move_left"):
		direction = "left"
	elif Input.is_action_just_pressed("move_right"):
		direction = "right"
	elif Input.is_action_just_pressed("move_down"):
		direction = "forward"
	else:
		return

	# give money OR transition out of idle if the movement is valid
	var success: bool = player.fund_neighbor(direction)
	if success:
		return

	# transition to walking if supplied direction is valid
	var is_valid: bool = player.check_move(direction)
	if !is_valid:
		return
	state_machine.transition_to("Walk", {"direction": direction})


# On exit, stop the current idle animation
func exit() -> void:
	animated_sprite.stop()
