extends KinematicBody2D

const TIMER_LIMIT = 3000
var timer = 0

export var attack = true
onready var target = Global.player 									# Reference player
onready var bullet_scene = preload("res://Enemies/Enemy_tower/EnemyTowerBullet.tscn") 	# Reference Bullet Scene
onready var stats = $Stats
export var attack_speed = 1 		# Tower Attack Speed
var flash_timer = 0 			# Timer so that the white flash is visible for a couple of frames

const GRAVITY = 200.0
var velocity = Vector2()

func _ready():
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
	
	if flash_timer > 0:
		flash_timer -= 1
	if flash_timer == 1:
		$Sprite.modulate = Color(1,1,1,1) # Returns to normal color

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	var motion = velocity * delta
	move_and_collide(motion)

func shoot_player():
	if attack == true:
		var bullet = bullet_scene.instance()		# Create a Bullet
		bullet.position = get_node("Position2D").position			# New Bullet have the position of the tower
		if target:									# If the target is alive execute below
			bullet.destination = target.position		# Bullet direction is the last position of the player
			get_parent().add_child(bullet)

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage					# Tower lose a life
	area.get_parent().queue_free()				# Anything that hits the tower is removed
	pass

func _on_Stats_no_health() -> void:
	queue_free()
