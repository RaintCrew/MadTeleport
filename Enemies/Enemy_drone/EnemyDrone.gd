extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone/DroneEnemyDeathEffect.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 80
export var FRICTION = 200
export var DURATION_OF_HURT_VFX = 5
enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var hurt_vfx_timer = -1 # Timer so that the vfx for being hurt is visible for a couple of frames
var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.player:	# If the player is on the map, the drone will chase him
		var direction = global_position.direction_to(Global.player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		sprite.flip_h = velocity.x < 0
		velocity = move_and_slide(velocity)
		
		decrease_hurt_vfx_timer()
	


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = velocity.move_toward(Vector2.ZERO, 300.0)
	sprite.modulate = Color(10,10,10,10) 	# Drone sprite turns white
	hurt_vfx_timer = DURATION_OF_HURT_VFX	# How long the vfx for being hit lasts
	area.get_parent().queue_free()			# Makes the bullet that caused the damage disappear

func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEfffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func decrease_hurt_vfx_timer():
	# When damaged, enemy will show a little visual effect.
	# So it can last longer than a frame, and therefore the player can see it,
	# this timer is used. When it hits 0, the visual effect is removed
	if hurt_vfx_timer >= 0:
		hurt_vfx_timer -= 1
	if hurt_vfx_timer == 0:
		sprite.modulate = Color(1,1,1,1)	# Returns to normal color
		sprite.scale = Vector2(1,1)		# Returns to normal size
