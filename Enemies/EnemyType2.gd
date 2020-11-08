extends KinematicBody2D

const TIMER_LIMIT = 3000
var timer = 0

onready var target = get_parent().get_node("Player")
onready var bullet_scene = preload("res://Enemies/EnemyBullet.tscn") 				# Referencia a escena de bala

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
	bullet.destination = target.get_global_position()
	get_parent().add_child(bullet)



#func _process(delta):
#	print(timer)
#	timer += delta
#	if(timer >= TIMER_LIMIT):
#		timer -= TIMER_LIMIT;
		
