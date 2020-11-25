extends Node2D

var level_tutorial = preload ("res://World/Level_Miguel/Level_Tutorial.tscn")
var level_1 = preload ("res://World/Level1/Level1.tscn")
var level_2 = preload ("res://World/Level2/Level2.tscn")
var level_3

export(int, "Tutorial", "Level 1", "Level 2", "Level 3") var level_select

func _ready() -> void:
	pass # Replace with function body.


func _on_TextureButton_pressed() -> void:
	if level_select == 0:
		get_tree().change_scene("res://World/Level_Miguel/Level_Tutorial.tscn")
	if level_select == 1:
		get_tree().change_scene("res://World/Level1/Level1.tscn")
	pass # Replace with function body.
