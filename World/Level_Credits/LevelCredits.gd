extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass



func _on_ButtonBack_pressed() -> void:
	get_tree().change_scene("res://World/Menu/MainMenu.tscn")
	pass
