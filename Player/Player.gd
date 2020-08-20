extends KinematicBody2D

#basic movement (will bemove into stats)
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
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
		

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	move()
	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)
	
	
	
