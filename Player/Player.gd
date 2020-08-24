extends KinematicBody2D
class_name Player
# Signal

signal player_fired_bullet(bullet, position, direction)

#basic movement (will be move into stats)
export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 500


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


onready var stats = $Stats
onready var weapon = $Weapon


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			pass

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

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move()
	state = MOVE # will be change after the animtio is in
	# method wil be called to back to move if te animaton is end
	
func move():
	velocity = move_and_slide(velocity)
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("Attack"):
		weapon.shoot()




