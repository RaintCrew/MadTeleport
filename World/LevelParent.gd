extends Node2D

onready var currentScene = get_tree().get_current_scene().get_filename()
var is_restarting = false
onready var camera_animation_player = $Camera/AnimationPlayer
onready var pause_popup = $PausePopup

func _ready():
	if Global.music:
		$bg_music.play()
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.ammo = PlayerStats.max_ammo
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		if not is_restarting:
			camera_animation_player.play("BlackScreenFadeIn")
			is_restarting = true
			yield(camera_animation_player, "animation_finished")
			get_tree().change_scene(currentScene)
			get_tree().paused = false
			PlayerStats.health = PlayerStats.max_health
			PlayerStats.ammo = PlayerStats.max_ammo

	if Input.is_action_just_pressed("esc"):
		if not is_restarting and !Global.player.player_dead:
			get_tree().paused = true
			yield(get_tree().create_timer(0.1), "timeout")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_popup.show()


func disable_all_spawners():
	for spawner in get_tree().get_nodes_in_group("all_enemy_spawners"):
		spawner.spawning = false
