extends State

export var animated_sprite_path = NodePath()
onready var animated_sprite = get_node(animated_sprite_path)

var direction


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
		state_machine.transition_to("Walk", {"direction": "backward"})
	elif Input.is_action_just_pressed("move_left"):
		state_machine.transition_to("Walk", {"direction": "left"})
	elif Input.is_action_just_pressed("move_right"):
		state_machine.transition_to("Walk", {"direction": "right"})
	elif Input.is_action_just_pressed("move_down"):
		state_machine.transition_to("Walk", {"direction": "forward"})


# On exit, stop the current idle animation
func exit() -> void:
	animated_sprite.stop()
