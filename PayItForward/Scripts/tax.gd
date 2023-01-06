extends State

# the animated sprite attached to this state
export var animated_sprite_path = NodePath()
onready var animated_sprite: AnimatedSprite = get_node(animated_sprite_path)

enum Multiplier {ZERO = 0, TWO = 2, THREE = 3, FOUR = 4, FIVE = 5}

export (Multiplier) var multiplier


# upon entering the state, we turn on the tax space
# can be 0 (for off), 2, 3, 4, or 5
func enter(_msg := {}) -> void:
	# play animation
	var move: int = _msg["move"]
	if move == 0:
		animated_sprite.play("off")
	if move == 2:
		animated_sprite.play("two")
	if move == 3:
		animated_sprite.play("three")
	if move == 4:
		animated_sprite.play("four")
	if move == 5:
		animated_sprite.play("five")


# On exit, stop the current animation
func exit() -> void:
	animated_sprite.stop()


# check the current move number and transition as needed
func check_move(move: int) -> void:
	if multiplier == Multiplier.ZERO:
		return
	
	if (move % multiplier) * multiplier == move:
		state_machine.transition_to("Off", {})
