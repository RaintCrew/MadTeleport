extends PopupDialog


onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc") and self.visible:
		self.hide()
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	# Hide/show the player crosshair depending on if the pause is on/off
	if player != null:
		player.crosshair.visible = not self.visible


func _on_ReturnLevelSelect_pressed():
	get_tree().change_scene("res://World/Level_Select/LevelSelect.tscn")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_QuitDesktop_pressed():
	get_tree().quit()
