extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

export var speed := 600.0
export var jump_strength := 2000.0
export var gravity := 4500.0

var velocity := Vector2.ZERO

func _physics_process(delta):
	var horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	
	var is_falling := velocity.y > 0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled := velocity.y < 0 and Input.is_action_just_released("jump")
	var is_idle := is_zero_approx(velocity.x) and  is_on_floor()
	var is_running := not is_zero_approx(velocity.x) and is_on_floor()
	
	if is_jumping:
		velocity.y = -jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_falling:
		pass
		
	
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
