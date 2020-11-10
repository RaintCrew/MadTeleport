extends Camera2D

##################################
# Sadly, I don't quite understand this code. Just took it from a tutorial
# Any other object in the scene can make this camera shake by setting
# its "shake" variable to true.
#
# Play with amplitude and duration variables
# to power up or down the shake effect
#################################

onready var timer : Timer = $Shake_Timer

export var amplitude : = 1.6
export var duration : = 0.1
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

var enabled : = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#set_process(false)
	self.duration = duration
	connect_to_shakers()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake:
		var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		offset = Vector2(
			rand_range(amplitude, -amplitude) * damping,
			rand_range(amplitude, -amplitude) * damping)
	
	$Flash.modulate.a += (0 - $Flash.modulate.a) * 0.2



func _on_camera_shake_requested():
	if not enabled:
		return
	self.shake = true

func set_duration(value):
	duration = value
	timer.wait_time = duration

func set_shake(value):
	shake = value
	#set_process(shake)
	offset = Vector2()
	if shake:
		timer.start(duration)

func connect_to_shakers():
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		camera_shaker.connect("camera shake requested", self, "_on_camera_shake_requested")
	
func _on_Timer_timeout():
	self.shake = false

func flash():
	$Flash.modulate.a = 1

