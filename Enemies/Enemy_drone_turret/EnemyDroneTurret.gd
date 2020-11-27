extends KinematicBody2D

const EnemyDeathEfffect = preload("res://Enemies/Enemy_drone_turret/DroneTurretDeathAnimation.tscn")

var velocity = Vector2()
var direction = 1

export var attack = true
export var attack_speed = 1.0 		# Tower Attack Speed

onready var stats = $Stats					# Load the stats script for the life
onready var hurtbox = $Hurtbox
onready var target = Global.player 									# Reference player
onready var bullet_scene = preload("res://Enemies/Enemy_tower/EnemyTowerBullet.tscn") 	# Reference Bullet Scene

func _ready() -> void:
	# Create a timer node
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

func _physics_process(delta: float) -> void:
	if is_on_wall():
		direction = direction * -1
	
	velocity.y = 0
	velocity.x =  50 * direction
	move_and_slide(velocity)
	
	$Position2D.position = position


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage										# Lose a health depending of hit damage


func _on_Stats_no_health() -> void:
	emit_signal("enemy_killed")
	queue_free() 													# Drone die
	var enemyDeathEffect = EnemyDeathEfffect.instance() 			# Set drone death animation
	get_parent().add_child(enemyDeathEffect)						# Play drone death animation
	enemyDeathEffect.global_position = global_position				# drone death animation it is positioned in the same place where the drone died

func shoot_player():
	if attack == true:
		var bullet = bullet_scene.instance()		# Create a Bullet
		bullet.position = get_node("Position2D").position			# New Bullet have the position of the tower
		if target:									# If the target is alive execute below
			bullet.destination = target.position		# Bullet direction is the last position of the player
			get_parent().add_child(bullet)
