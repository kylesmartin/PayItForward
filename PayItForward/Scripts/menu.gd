extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_TextureButton_mouse_entered():
	$BtnHover.play()


func _on_TextureButton_button_down():
	$BtnClick.play()
