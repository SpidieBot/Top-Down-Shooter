extends Node2D
class_name Weapon

signal weapon_fired(bullet, position, direction)

#bullet
export (PackedScene) var Bullet

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var attack_timer = $AttackTimer


func shoot():
	if attack_timer.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		bullet_instance.global_position = end_of_gun.global_position
		bullet_instance.set_direction(direction)
		get_tree().get_root().add_child(bullet_instance)
			
		attack_timer.start()
		
