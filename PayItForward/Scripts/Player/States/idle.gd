extends State

export var animated_sprite_path = NodePath()

onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)

export var player_path = NodePath()

onready var player: Player = get_node(player_path)


# Upon entering the state, we set the animation state to idle with a given direction
func enter(_msg := {}) -> void:
	# if no message provided, default to forward
	if !_msg.has("direction"):
		print("No direction provided to idle state, defaulting to forward")
		animated_sprite.play("idle_forward")
		return

	# loop idle animation
	animated_sprite.play("idle_%s" % _msg["direction"])


func update(delta: float) -> void:
	if !is_active or !player.is_active:
		return

	# give money OR transition out of idle if the movement is valid
	if Input.is_action_just_pressed("move_up"):
		var success: bool = player.fund_neighbor("backward")
		if success:
			return
		_transition_if_valid("backward")
	elif Input.is_action_just_pressed("move_left"):
		var success: bool = player.fund_neighbor("left")
		if success:
			return
		_transition_if_valid("left")
	elif Input.is_action_just_pressed("move_right"):
		var success: bool = player.fund_neighbor("right")
		if success:
			return
		_transition_if_valid("right")
	elif Input.is_action_just_pressed("move_down"):
		var success: bool = player.fund_neighbor("forward")
		if success:
			return
		_transition_if_valid("forward")


# transitions to walking if player is able to move in given direction
func _transition_if_valid(_direction: String) -> void:
	var is_valid: bool = player.check_move(_direction)
	if !is_valid:
		return
	state_machine.transition_to("Walk", {"direction": _direction})


# On exit, stop the current idle animation
func exit() -> void:
	animated_sprite.stop()
