extends "res://Enemies/EnemyDeathEffect.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TowerEnemyDrathEffect_frame_changed():
	if frame == 10:
		OS.delay_msec(50)
		$Audio_Explosion.play()
		camera.activate_shake(4.0,0.3)
