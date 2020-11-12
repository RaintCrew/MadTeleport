extends Node

var node_creation_parent = null
var player = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

#for now this function works to help spawn enemies
func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance


