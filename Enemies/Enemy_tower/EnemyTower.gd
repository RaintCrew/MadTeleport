extends KinematicBody2D

const GRAVITY = 10.0
const TIMER_LIMIT = 3000
const EnemyDeathEffect = preload("res://Enemies/Enemy_tower/TowerEnemyDrathEffect.tscn")

export var attack = true
export var attack_speed = 1.0 		# Tower Attack Speed

onready var target = Global.player 									# Reference player
onready var bullet_scene = preload("res://Enemies/Enemy_tower/EnemyTowerBullet.tscn") 	# Reference Bullet Scene
onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var level = get_parent().get_parent()

var timer = 0
var velocity = Vector2()

# We use a signal because it's the child who wants to tell something to the parent.
signal enemy_killed

func _ready():
	connect("enemy_killed",level,"add_to_enemies_killed")	# The Level script hears this to check when to change the current level phase
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
	

func _physics_process(delta):
	velocity.y += GRAVITY
	move_and_slide(velocity)
	$Position2D.position = self.position + Vector2(0,-30)

func shoot_player():
	if PlayerStats.health > 0:
		if attack == true:
			var bullet = bullet_scene.instance()		# Create a Bullet
			bullet.position = get_node("Position2D").position			# New Bullet have the position of the tower
			if target:									# If the target is alive execute below
				bullet.destination = target.position		# Bullet direction is the last position of the player
				get_parent().add_child(bullet)

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage					# Tower lose a life
	area.get_parent().queue_free()				# Anything that hits the tower is removed
	
	$Audio_Hit.play()
	sprite.modulate = Color(10,10,10,10)
	OS.delay_msec(20)
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate = Color(1,1,1,1)
	

func _on_Stats_no_health() -> void:
	emit_signal("enemy_killed")
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance() 				# Set enemy death animation
	get_parent().add_child(enemyDeathEffect)						# Play enemy death animation
	enemyDeathEffect.global_position = global_position				# drone death animation it is positioned in the same place where the enemy died
