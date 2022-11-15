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

	animated_sprite.play("idle_%s" % _msg["direction"])


func update(delta: float) -> void:
	if !is_active:
		return

	if Input.is_action_just_pressed("move_up"):
		_transition_if_valid("backward")
	elif Input.is_action_just_pressed("move_left"):
		_transition_if_valid("left")
	elif Input.is_action_just_pressed("move_right"):
		_transition_if_valid("right")
	elif Input.is_action_just_pressed("move_down"):
		_transition_if_valid("forward")


func _transition_if_valid(_direction: String) -> void:
	var is_valid: bool = player.check_move(_direction)
	if !is_valid:
		return
	state_machine.transition_to("Walk", {"direction": _direction})


# On exit, stop the current idle animation
func exit() -> void:
	animated_sprite.stop()
