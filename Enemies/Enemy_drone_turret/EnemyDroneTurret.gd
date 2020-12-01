extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone_turret/DroneTurretDeathAnimation.tscn")

export var DURATION_OF_HURT_VFX = 5

var velocity = Vector2()
var direction = 1
var hurt_vfx_timer = -1 # Timer so that the vfx for being hurt is visible for a couple of frames

export var attack = true
export var attack_speed = 1.0 		# Tower Attack Speed

onready var stats = $Stats					# Load the stats script for the life
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite		# Load the sprite.
onready var turret = $Position2D
onready var target = Global.player 									# Reference player
onready var bullet_scene = preload("res://Enemies/Enemy_tower/EnemyTowerBullet.tscn") 	# Reference Bullet Scene
onready var level = get_parent().get_parent()

signal enemy_killed

func _ready() -> void:
	connect("enemy_killed",level,"add_to_enemies_killed")	# The Level script hears this to check when to change the current level phase
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(attack_speed)
	# Set it as repeat
	timer.set_one_shot(false)
	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", self, "shoot_player")
	# Add to the tree as child of the current node
	add_child(timer)
	timer.start()
	pass

func _process(delta: float) -> void:
	decrease_hurt_vfx_timer()

func _physics_process(delta: float) -> void:
	if is_on_wall():
		direction = direction * -1
	velocity.y = 0
	velocity.x =  50 * direction
	move_and_slide(velocity)
	turret.position = position


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

func shoot_player():
	if attack == true:
		var bullet = bullet_scene.instance()		# Create a Bullet
		bullet.position = get_node("Position2D").position			# New Bullet have the position of the tower
		if target:									# If the target is alive execute below
			bullet.destination = target.position		# Bullet direction is the last position of the player
			get_parent().add_child(bullet)
