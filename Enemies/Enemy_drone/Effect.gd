extends AnimatedSprite

func _ready() -> void:
	connect("animation_finished", self, "_on_animation_finished")
	play("DeathAnimation")

func _on_animation_finished():
	queue_free()
