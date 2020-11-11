extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/EnemyDrone/DroneEnemyDeathEffect.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 80
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.player:
		var direction = global_position.direction_to(Global.player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		sprite.flip_h = velocity.x < 0
		velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -=1
	velocity = velocity.move_toward(Vector2.ZERO, 300.0)
	

func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEfffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	

