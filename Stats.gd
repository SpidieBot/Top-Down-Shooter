extends Node2D


export (int) var health = 1 setget set_health
export (float) var damage = 20

func set_health(new_health):
	#clamp is basicly keeping the number between 0 to 100
	health = clamp(new_health, 0, 100)

