extends AnimatedSprite

onready var camera = null
#
# Here the animations of death of the enemies are processed
#

func _ready() -> void:
	connect("animation_finished", self, "_on_animation_finished") 	# connect the animation the object (enemy) and execute the function _on_animation_finished
	play("DeathAnimation") 											# Execute death Animation
	if get_parent().name == "Level_Parra":
		camera = get_parent().get_node("Camera")
	else:
		camera = get_parent().get_parent().get_node("Camera")


func _on_animation_finished():
	queue_free() 					# When the animation ends the object is deleted


func _on_DroneEnemyDeathEffect_frame_changed():
	if frame == 9:
		$Audio_Explosion.play()
		camera.activate_shake(3.0,0.4)
