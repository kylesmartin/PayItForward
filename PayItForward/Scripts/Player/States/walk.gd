extends State

export var animated_sprite_path = NodePath()
onready var animated_sprite = get_node(animated_sprite_path)

var direction


# Upon entering the state, we set the animation state to walk with a given direction
func enter(_msg := {}) -> void:
	direction = _msg["direction"]
	animated_sprite.play("walk_%s" % direction)


# On exit, stop the current idle animation
func exit() -> void:
	animated_sprite.stop()


func _on_Sprite_animation_finished() -> void:
	if !is_active:
		return

	state_machine.transition_to("Idle", {"direction": direction})
