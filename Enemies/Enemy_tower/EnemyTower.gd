extends KinematicBody2D

const TIMER_LIMIT = 3000
var timer = 0

onready var target = get_parent().get_node("Player")
onready var bullet_scene = preload("res://Enemies/Enemy_tower/EnemyTowerBullet.tscn") 				# Referencia a escena de bala
onready var stats = $Stats

func _ready():
	# Create a timer node
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(1.0)
	# Set it as repeat
	timer.set_one_shot(false)
	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", self, "repeat_me")
	# Add to the tree as child of the current node
	add_child(timer)
	timer.start()


func repeat_me():
	var bullet = bullet_scene.instance()	
	bullet.position = global_position
	if target:
		bullet.destination = target.get_global_position()
		get_parent().add_child(bullet)

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -=1
	pass

func _on_Stats_no_health() -> void:
	queue_free()
