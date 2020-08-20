extends Area2D
class_name Bullet

export (int) var SPEED = 10

onready var kill_timer = $KillTimer

var direction = Vector2.ZERO

func _ready():
	kill_timer.start()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * SPEED
		
		global_position += velocity
	
	
	
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_illTimer_timeout():
	queue_free()
