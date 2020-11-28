extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone/DroneEnemyDeathEffect.tscn") # Load drone death animation

export var SPEED : = 100.0
export var ACCELERATION = 200
export var MAX_SPEED = 80		# Movement speed
export var FRICTION = 200		# Slowdown speed when the player hits drone
export var DURATION_OF_HURT_VFX = 5
var velocity = Vector2.ZERO
var hurt_vfx_timer = -1 # Timer so that the vfx for being hurt is visible for a couple of frames
var path := PoolVector2Array() setget set_path

onready var nav_2d : Navigation2D = get_parent().get_parent().get_node("Navigation2D")
onready var hitbox = $Hitbox
onready var hitbox_collision_shape = $Hitbox/CollisionShape2D
onready var sprite = $AnimatedSprite		# Load the sprite.
onready var stats = $Stats					# Load the stats script for the life
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var line_2d = get_parent().get_parent().get_node("Line2D")
onready var level = get_parent().get_parent()
onready var player = get_parent().get_parent().get_node("Player")

# We use a signal because it's the child who wants to tell something to the parent.
signal enemy_killed

func _ready() -> void:
	connect("enemy_killed",level,"add_to_enemies_killed")	# The Level script hears this to check when to change the current level phase
	pass

func _process(delta: float) -> void:
	if PlayerStats.health > 0: 			# If the player is alive execute below code
		# path from the drone to the player
		var path_to_player = nav_2d.get_simple_path(global_position,player.global_position)
		# line drawn based on the path to the player
		#line_2d.points = path_to_player
		path = path_to_player
		
		var move_distance : = SPEED * delta
		move_along_path(move_distance, delta)
		#chase_player(delta)
	else:
		hitbox_collision_shape.disabled = true
	decrease_hurt_vfx_timer()

# pathfinding baby
func move_along_path(distance, delta):
	
	# starting point in the path
	var start_point : = global_position
	# move the player along the path until there aren't points
	for _i in range(path.size()):
		
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			# this means that the player teleported themself
			if distance_to_next == 0:
				return
			global_position = start_point.linear_interpolate(path[0], min(distance, distance_to_next) / distance_to_next)
			break
		elif path.size() == 1 and distance > distance_to_next:
			global_position = path[0]
			chase_player(delta)
			break
			
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
	
func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return

func move_along_path3(distance_to_walk):
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

func move_along_pathR(distance):
	# Ensure we have an actual path, otherwise we are done and can stop
	# processing
	if path.size() == 0:
		set_process(false)
		return
	
	# If there's no distance available to travel, then nothing to do for this
	# tick
	if distance <= 0.0:
		return
	
	# Check how far until the next point
	var distance_to_next_point : = position.distance_to(path[0])
	
	# Assuming there's some distance left to go, let's move it
	if distance_to_next_point > 0.0:
		# Use the min of distance and distance_to_next_point so that we don't
		# overshoot our destination when distance > distance_to_next_point
		position = position.linear_interpolate(path[0], min(distance, distance_to_next_point) / distance_to_next_point)

	# If this condition is met, we must have reached destination, so remove point
	if distance >= distance_to_next_point:
		path.remove(0)
	
	# Subtract the amount we used up before moving further along the path.  If
	# there is no distance left, the next call will check this at the start
	# and return
	move_along_pathR(distance - distance_to_next_point)

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
func _on_Hitbox_area_entered(_area):
	hitbox.knockback_vector = velocity.normalized()
