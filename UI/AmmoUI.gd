extends Control

var max_ammo = 6 setget set_max_ammo
var ammo = max_ammo setget set_ammo

onready var ammoUIFull = $AmmoUIFull
onready var ammoUIEmpty = $AmmoUIEmpty

func set_ammo(value):
	# clamp sets ammo so that it can't be less than 0 nor greather than max_ammo.
	ammo = clamp(value, 0, max_ammo)
	# this will set the size of the rect with strecth of tile, to be the ammo times 
	# the size of each bullet.
	if ammoUIFull:
		ammoUIFull.rect_size.x = ammo * 7
	
func set_max_ammo(value):
	# max_ammo value won't never be less than 1.
	max_ammo = max(value, 1)
	# same as above.
	self.ammo = min(ammo, max_ammo)
	if ammoUIEmpty:
		ammoUIEmpty.rect_size.x = max_ammo * 7
	
func _ready():
	self.max_ammo = PlayerStats.max_ammo
	self.ammo = PlayerStats.ammo
	PlayerStats.connect("ammo_changed", self, "set_ammo")
	PlayerStats.connect("max_ammo_changed", self, "set_max_ammo")
