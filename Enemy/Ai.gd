extends Node2D

signal state_changed(new_state)

enum State{
	PATROL,
	ENGAGE
}

onready var player_etection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

var current_state: int = -1 setget set_state
var actor: KinematicBody2D = null
var player: Player = null
var weapon: Weapon = null

# PATROL STATE
var origin = Vector2.ZERO
var patrol_location = Vector2.ZERO
var patrol_locaton_reached = false
var actor_velocity = Vector2.ZERO

func _ready():
	set_state(State.PATROL)

func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_locaton_reached:
				actor.move_and_slide(actor_velocity)
				var angel_to_direction = actor.global_position.direction_to(patrol_location).angle()				
				actor.rotation = lerp(actor.rotatiom, angel_to_direction, 0.1 )
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_locaton_reached = true
					actor_velocity =Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE: 
			if player != null and weapon != null:
				var angel_to_player = actor.global_position.direction_to(player.global_position).angle()
				actor.rotation = lerp(actor.rotation, angel_to_player, 0.1)
				# MAKING A SHOOT ONLY WHN FACE AT PLAYER
				if abs(actor.rotation - angel_to_player) < 0.1:
					weapon.shoot()
			else:
				print("in the engage state but no weapon")
		_:
			print("error found state that should not exist")
		

func initialize(actor, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon

func set_state(new_state):
	if new_state == current_state:
		return
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_locaton_reached = true
		
	current_state = new_state
	emit_signal("state_changed", current_state)
	



func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body


func _on_PlayerDetectionZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL)
		player = null


func _on_PatrolTimer_timeout():
	actor_velocity = Vector2.ZERO
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_locaton_reached = false
	actor_velocity = actor.global_position.direction_to(patrol_location) * 100
