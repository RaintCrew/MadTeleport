extends TextureRect

onready var mouse = get_node("mouse")

func _ready() -> void:
	$MusicDisable.hide()
	pass

func _physics_process(delta):
	mouse.global_position = get_global_mouse_position()


func _on_BackArrow_pressed() -> void:
	get_tree().change_scene("res://World/Menu/MainMenu.tscn")
	pass


func _on_MusicAvailable_pressed() -> void:
	$bg_music.stop()
	$MusicAvailable.hide()
	$MusicDisable.show()
	pass


func _on_MusicDisable_pressed() -> void:
	$bg_music.play()
	$MusicAvailable.show()
	$MusicDisable.hide()
	pass
