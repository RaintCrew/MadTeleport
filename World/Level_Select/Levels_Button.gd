extends Node2D

export(int, "Tutorial", "Level 1", "Level 2", "Level 3") var level_select

func _ready() -> void:
	pass

func _on_TextureButton_pressed() -> void:
	if level_select == 0:
		get_tree().change_scene("res://World/Level_Tutorial/Level_Tutorial.tscn")
	if level_select == 1:
		get_tree().change_scene("res://World/Level1/Level1.tscn")
	if level_select == 2:
		get_tree().change_scene("res://World/Level2/Level2.tscn")
	if level_select == 3:
		get_tree().change_scene("res://World/Level3/Level3.tscn")
	pass
