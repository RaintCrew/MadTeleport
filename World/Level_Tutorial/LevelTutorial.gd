extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_Area2D_body_entered(body: Node) -> void:
	get_tree().change_scene("res://World/Level1/Level1.tscn")
