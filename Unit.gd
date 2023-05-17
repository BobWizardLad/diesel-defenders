extends CharacterBody2D

@export
var Speed = 50

var target = Vector2.ZERO

func _physics_process(delta):
	var distance = (target - position).length()
	
	# Input to set destination
	if (Input.is_action_pressed("Rclick")):
		target = get_global_mouse_position()
		
	
	# Move as long as there is a distance to target or stop
	if (distance > 1.0):
		velocity = position.direction_to(target).normalized() * Speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
