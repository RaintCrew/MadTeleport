extends Node2D
onready var pause_popup = $PausePopup

func _ready() -> void:
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.ammo = PlayerStats.max_ammo
	
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		yield(get_tree().create_timer(0.1), "timeout")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_popup.show()

func _on_Area2D_body_entered(body: Node) -> void:
	get_tree().change_scene("res://World/Level1/Level1.tscn")
