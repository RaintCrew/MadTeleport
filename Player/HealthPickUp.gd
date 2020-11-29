extends Area2D

var damage = -1

func _ready() -> void:
	pass

func _on_HealthPickup_area_entered(area: Area2D) -> void:
	print("hola")
	queue_free()
	pass
