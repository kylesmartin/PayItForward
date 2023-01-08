extends State

# the animated sprite attached to this state
export var animated_sprite_path = NodePath()
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)

export var animation_name: String

# turn on the state
func enter(_msg := {}) -> void: 
	animated_sprite.play(animation_name)


# upon exit, stop the current animation
func exit() -> void:
	animated_sprite.stop()
