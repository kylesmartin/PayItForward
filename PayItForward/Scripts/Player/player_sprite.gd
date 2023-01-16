extends AnimatedSprite


export var player_path = NodePath()
onready var player: Player = get_node(player_path)

export var balance_sprite_path = NodePath()
onready var balance_sprite: CanvasItem = get_node(balance_sprite_path)

var above_threshold = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.id == 1:
		self.material.set_shader_param("r", 0.99)
		self.material.set_shader_param("g", 1)
		self.material.set_shader_param("b", 0.54)
	elif player.id == 2:
		self.material.set_shader_param("r", 1)
		self.material.set_shader_param("g", 1)
		self.material.set_shader_param("b", 1)
	elif player.id == 3:
		self.material.set_shader_param("r", 0.37)
		self.material.set_shader_param("g", 0.99)
		self.material.set_shader_param("b", 0.97)
	elif player.id == 4:
		self.material.set_shader_param("r", 1)
		self.material.set_shader_param("g", 0.36)
		self.material.set_shader_param("b", 0.8)
		
	if player.is_finished and not above_threshold:
		balance_sprite.hide()
		position -= Vector2(0, 200 * delta)
		if position.y < -200:
			above_threshold = true
			
	if player.failed:
		balance_sprite.hide()
