extends AnimatedSprite

#
# Here the animations of death of the enemies are processed
#

func _ready() -> void:
	connect("animation_finished", self, "_on_animation_finished") # connect the animation the object (enemy) and execute the function _on_animation_finished
	play("DeathAnimation") # Execute death Animation

func _on_animation_finished():
	queue_free() # When the animation ends the object is deleted
