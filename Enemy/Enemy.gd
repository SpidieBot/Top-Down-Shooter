extends KinematicBody2D

onready var stats = $Stats

func handle_hit():
	stats.health -= stats.damage
	print("player hit ", stats.health)
