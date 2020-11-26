extends Node2D

var newGame_button_animation = preload("res://World/Menu/Menu_NewGame_Animation.tscn")

onready var mouse = get_node("mouse")

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	mouse.global_position = get_global_mouse_position()


func _on_ButtonNewGame_pressed() -> void:
	var newGame_animation = newGame_button_animation.instance()
	get_parent().add_child(newGame_animation)
	newGame_animation.global_position = Vector2(319.913,179.802)
	pass # Replace with function body.
