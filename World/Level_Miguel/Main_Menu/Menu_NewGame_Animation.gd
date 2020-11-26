extends AnimatedSprite

func _ready() -> void:
	play("defaul")
	pass # Replace with function body.              


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
	get_tree().change_scene("res://World/Level_Miguel/Level_Select.tscn")   
