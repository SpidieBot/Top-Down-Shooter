extends KinematicBody2D

onready var stats = $Stats
onready var ai = $Ai
onready var weapon = $Weapon

func _ready():
	ai.initialize(self, weapon)

func handle_hit():
	stats.health -= stats.damage
	print("player hit ", stats.health)

