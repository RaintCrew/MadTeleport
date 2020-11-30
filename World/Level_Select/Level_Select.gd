extends TextureRect

func _ready() -> void:
	pass

func _on_BackArrow_pressed() -> void:
	get_tree().change_scene("res://World/Menu/MainMenu.tscn")
	pass
