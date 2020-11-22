extends Node2D

func _ready() -> void:
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.47 - window_size*0.5)

func _on_Area2D_body_entered(body: Node) -> void:
	get_tree().change_scene("res://World/Level1/Level1.tscn")
