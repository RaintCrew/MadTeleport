extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone/DroneEnemyDeathEffect.tscn") # Load drone death animation

export var ACCELERATION = 200
export var MAX_SPEED = 80		# Movement speed
export var FRICTION = 200		# Slowdown speed when the player hits drone

var velocity = Vector2.ZERO
var flash_timer = 0 			# Timer so that the white flash is visible for a couple of frames

onready var sprite = $AnimatedSprite		# Load the sprite.
onready var stats = $Stats					# Load the stats script for the life

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.player: 			# If the player is alive execute below code
		chase_player(delta)
	
	if flash_timer > 0:
		flash_timer -= 1
	if flash_timer == 1:
		$AnimatedSprite.modulate = Color(1,1,1,1) # Returns to normal color

func chase_player(delta: float):
	var direction = global_position.direction_to(Global.player.global_position)		# Check player position
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)	# Sets the drone speed
	sprite.flip_h = velocity.x < 0													# change the orientation  of the sprite depending on the direction of the player
	velocity = move_and_slide(velocity)												# move the drone

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage										# Lose a health depending of hit damage
	velocity = velocity.move_toward(Vector2.ZERO, 300.0)			# Hitting the drone causes it to slow down
	$AnimatedSprite.modulate = Color(10,10,10,10) 					# Turns white
	flash_timer = 6
	area.get_parent().queue_free()									# Delete everything that damages the drone

func _on_Stats_no_health() -> void:
	queue_free() 													# Drone die
	var enemyDeathEffect = EnemyDeathEfffect.instance() 			# Set drone death animation
	get_parent().add_child(enemyDeathEffect)						# Play drone death animation
	enemyDeathEffect.global_position = global_position				# drone death animation it is positioned in the same place where the drone died
	

