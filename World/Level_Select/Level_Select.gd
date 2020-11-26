extends TextureRect

onready var mouse = get_node("teleport_ball_mouse")

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	mouse.global_position = get_global_mouse_position()
