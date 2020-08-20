extends KinematicBody2D

#basic movement (will bemove into stats)
export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 500

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



func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
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
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
		

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	move()
	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("Attack"):
		shoot()

func shoot():
	var bullet_instance = Bullet.instance()
	add_child(bullet_instance)
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
