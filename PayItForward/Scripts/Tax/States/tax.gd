extends State

# the animated sprite attached to this state
export var animated_sprite_path = NodePath()
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)


# upon entering the state, we turn on the tax space
# can be 2, 3, 4, or 5
func enter(_msg := {}) -> void:
	var multiple: int = _msg["multiple"]
	animated_sprite.play("tax_%d" % multiple)


# On exit, stop the current animation
func exit() -> void:
	animated_sprite.stop()
