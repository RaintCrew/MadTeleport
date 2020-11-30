extends Node

var node_creation_parent = null
var player = null
var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()

var music = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#this centers the game window
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func _process(delta):
	if Input.is_action_just_pressed("full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
#for now this function works to help spawn enemies
func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance


