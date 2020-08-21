extends KinematicBody2D

var health = 100

func handle_hit():
	health -= 20
	print("player hit ", health)
