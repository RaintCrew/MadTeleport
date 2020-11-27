extends AnimatedSprite

func _ready() -> void:
	play("defaul")
	pass # Replace with function body.              


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
	get_tree().change_scene("res://World/Level_Select/Level_Select.tscn")   


func _on_AnimatedSprite_frame_changed() -> void:
	if frame == 21:
		$TextureRect.hide()
		$TextureRect2.hide()
	pass # Replace with function body.
