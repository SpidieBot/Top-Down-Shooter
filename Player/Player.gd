extends KinematicBody2D

# Signal

signal player_fired_bullet(bullet, position, direction)

#basic movement (will be move into stats)
export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 500

#temp testing
var health = 100

#bullet
export (PackedScene) var Bullet

#the state of the player
enum{
	MOVE,
	ROLL,
	ATTACK
}

#state start from movement
var state = MOVE
# initialize the velocty into zero (IDLE state)
var velocity = Vector2.ZERO
#everythin start facing down
var roll_vector = Vector2.DOWN

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var attack_timer = $AttackTimer



func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: #MOVE
		#ROLL will always face the lastinput movement
		roll_vector = input_vector
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else: # IDLE
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()
	
	# Rotate the player sprite
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move()
	state = MOVE # will be change after the animtio is in
	# method wil be called to back to move if te animaton is end
	
func move():
	velocity = move_and_slide(velocity)
	

func attack_state():
	if attack_timer.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		bullet_instance.global_position = end_of_gun.global_position
		bullet_instance.set_direction(direction)
		get_tree().get_root().add_child(bullet_instance)
		
		attack_timer.start()
		state = MOVE

func handle_hit():
	health -= 20
	print("player hit ", health)
	
