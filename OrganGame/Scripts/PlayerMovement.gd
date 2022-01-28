extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

# movement variables
export var speed := 600.0
export var jump_speed := 50.0
export var max_speed_offset := 50.0

# jump variables
export var jump_strength := 2000.0
export var gravity := 4500.0

# movement velocity
var velocity := Vector2.ZERO

func _physics_process(delta):
	# calculate horizontal direction based on player input
	# -1 when moving left 1 when moving right
	var horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
		)
	
	if Input.is_action_just_pressed("test"):
		change_velocity(Vector2(-200, -1000))
	# if player is on ground, horizontal velocity is directly set to speed * direction
	elif is_on_floor():
		set_velocity(Vector2(horizontal_direction * speed, 0))
		
	# if player is in air, horizontal velocity is gradually changed and clamped between 
	# speed + offset and negative speed - offset
	else:
		change_velocity(Vector2(horizontal_direction * jump_speed, 0))
		velocity.x = clamp(velocity.x, -speed - max_speed_offset, speed + max_speed_offset)
	
	# vertical velocity is dependant on time
	change_velocity(Vector2(0, gravity * delta))
	
	# boolean variables for state checking
	# *** later use with animations ***
	var is_falling := velocity.y > 0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled := velocity.y < 0 and Input.is_action_just_released("jump")
	var is_idle := is_zero_approx(velocity.x) and  is_on_floor()
	var is_running := not is_zero_approx(velocity.x) and is_on_floor()
	
	# state handling
	if is_jumping:
		set_velocity(Vector2(velocity.x, -jump_strength))
	elif is_jump_cancelled:
		set_velocity(Vector2(velocity.x, 0.0))
		
	# moves player with move_and_slide and sets velocity to the calculated velocity
	set_velocity(move_and_slide(velocity, UP_DIRECTION))
	
func set_velocity(new_velocity : Vector2):
	velocity = new_velocity
func change_velocity(movement : Vector2):
	velocity += movement
	
