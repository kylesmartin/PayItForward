extends Node


export var player_path := NodePath()
onready var player: Player = get_node(player_path) as Player

export var state_machine_path := NodePath()
onready var state_machine: StateMachine = get_node(state_machine_path) as StateMachine


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_machine.transition_to(str(player.balance), {})

	if player.is_active:
		print("player %d is active" % player.id)
		self.material.set_shader_param("selected", true)
		self.material.set_shader_param("r", 0.55)
		self.material.set_shader_param("g", 0.85)
		self.material.set_shader_param("b", 0.58)
	else:
		self.material.set_shader_param("selected", false)
		self.material.set_shader_param("r", 1)
		self.material.set_shader_param("g", 1)
		self.material.set_shader_param("b", 1)
