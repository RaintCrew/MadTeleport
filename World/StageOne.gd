extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene("res://World/Main.tscn")
		get_tree().paused = false
		PlayerStats.health = PlayerStats.max_health


func _on_Trigger_body_entered(body):
	pass # Replace with function body.
