extends Area2D

var heal = 1

func _ready() -> void:
	pass

func _on_HealthPickup_area_entered(area: Area2D) -> void:
	queue_free()
