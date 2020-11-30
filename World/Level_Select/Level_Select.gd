extends TextureRect

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_BackArrow_pressed() -> void:
	get_tree().change_scene("res://World/Menu/MainMenu.tscn")
	pass
