extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone/DroneEnemyDeathEffect.tscn") # Load drone death animation

export var ACCELERATION = 200
export var MAX_SPEED = 80		# Movement speed
export var FRICTION = 200		# Slowdown speed when the player hits drone
export var DURATION_OF_HURT_VFX = 5
var velocity = Vector2.ZERO
var hurt_vfx_timer = -1 # Timer so that the vfx for being hurt is visible for a couple of frames

onready var hitbox = $Hitbox
onready var hitbox_collision_shape = $Hitbox/CollisionShape2D
onready var sprite = $AnimatedSprite		# Load the sprite.
onready var stats = $Stats					# Load the stats script for the life
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var level = get_parent().get_parent()

# We use a signal because it's the child who wants to tell something to the parent.
signal enemy_killed

func _ready() -> void:
	connect("enemy_killed",level,"add_to_enemies_killed")	# The Level script hears this to check when to change the current level phase
	pass

func _process(delta: float) -> void:
	if PlayerStats.health > 0: 			# If the player is alive execute below code
		chase_player(delta)
	else:
		hitbox_collision_shape.disabled = true
	decrease_hurt_vfx_timer()

func chase_player(delta: float):
	var direction = global_position.direction_to(Global.player.global_position)		# Check player position
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)	# Sets the drone speed
	sprite.flip_h = velocity.x < 0													# change the orientation  of the sprite depending on the direction of the player
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)												# move the drone

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage										# Lose a health depending of hit damage
	
	velocity = velocity.move_toward(Vector2.ZERO, 300.0)			# Hitting the drone causes it to slow down
	sprite.modulate = Color(10,10,10,10) 	# Drone sprite turns white
	$Audio_Hit.play()
	OS.delay_msec(20)
	hurt_vfx_timer = DURATION_OF_HURT_VFX	# How long the vfx for being hit lasts
	area.get_parent().queue_free()									# Delete everything that damages the drone

func _on_Stats_no_health() -> void:
	emit_signal("enemy_killed")
	queue_free() 													# Drone die
	var enemyDeathEffect = EnemyDeathEfffect.instance() 			# Set drone death animation
	get_parent().add_child(enemyDeathEffect)						# Play drone death animation
	enemyDeathEffect.global_position = global_position				# drone death animation it is positioned in the same place where the drone died
	
func decrease_hurt_vfx_timer():
	# When damaged, enemy will show a little visual effect.
	# So it can last longer than a frame, and therefore the player can see it,
	# this timer is used. When it hits 0, the visual effect is removed
	if hurt_vfx_timer >= 0:
		hurt_vfx_timer -= 1
	if hurt_vfx_timer == 0:
		sprite.modulate = Color(1,1,1,1)	# Returns to normal color

	# this set the normalized knocback vector on the enemydrone's hitbox
func _on_Hitbox_area_entered(area):
	hitbox.knockback_vector = velocity.normalized()
