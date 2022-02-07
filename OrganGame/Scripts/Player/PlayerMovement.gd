extends KinematicBody2D

# State variables
enum MovementState{ Idle, Walking, Jumping, Falling, JumpCancelled, Damaged }
var current_state = MovementState.Idle

# movement variables
const UP_DIRECTION := Vector2.UP

export var speed := 600.0
export var jump_speed := 50.0
export var max_speed_offset := 50.0

var velocity := Vector2.ZERO

# jump variables
export var jump_strength := 2000.0
export var gravity := 4500.0

# animation variables
onready var anim := $AnimatedSprite

# damage variables
onready var timer := $DamageTimer


func _ready():
	set_state(MovementState.Idle)

func _physics_process(delta):
	# gravity
	change_velocity(Vector2(0, gravity * delta))
	
	if current_state != MovementState.Damaged:
		# calculate horizontal direction based on player input
		# -1 when moving left 1 when moving right
		var horizontal_direction = (
			Input.get_action_strength("move_right")
			- Input.get_action_strength("move_left")
			)
			
		# if player is on ground, horizontal velocity is directly set to speed * direction
		if is_on_floor():
			set_velocity(Vector2(horizontal_direction * speed, 0))
		# if player is in air, horizontal speed changes gradually
		else:
			change_velocity(Vector2(horizontal_direction * jump_speed, 0))
			# clamps the velocity so the player can't move too fast
			velocity.x = clamp(velocity.x, -speed - max_speed_offset, speed + max_speed_offset)
		
		# state change
		if Input.is_action_just_pressed("jump") and is_on_floor():
			set_state(MovementState.Jumping)
		elif velocity.y < 0 and Input.is_action_just_released("jump"):
			set_state(MovementState.JumpCancelled)
		elif velocity.y > 0 and not is_on_floor():
			set_state(MovementState.Falling)
		elif not is_zero_approx(velocity.x) and is_on_floor():
			set_state(MovementState.Walking)
		elif is_zero_approx(velocity.x) and is_on_floor():
			set_state(MovementState.Idle)
		
		if horizontal_direction < 0 and scale.x != -1:
			anim.set_flip_h(true)
		elif horizontal_direction > 0:
			anim.set_flip_h(false)
	
	# moves player with move_and_slide and sets velocity to the calculated velocity
	set_velocity(move_and_slide(velocity, UP_DIRECTION))
	
# setter for the velocity variable
func set_velocity(new_velocity : Vector2):
	velocity = new_velocity
# adds the movement vector to the velocity
func change_velocity(movement : Vector2):
	velocity += movement
	
# changes the state and calls the handler function
func set_state(new_state):
	current_state = new_state
	handle_state()
# handles state changes
func handle_state():
	match current_state:
		MovementState.Jumping:
			set_velocity(Vector2(velocity.x, -jump_strength))
			anim.play("JumpFull")
		MovementState.JumpCancelled:
			set_velocity(Vector2(velocity.x, 0.0))
		MovementState.Walking:
			anim.play("Walk")
		MovementState.Idle:
			anim.play("Idle")
		MovementState.Damaged:
			set_velocity(Vector2(1000, -2000))
			anim.play("Damage")
			anim.set_frame(0)
			
func _on_HurtBox_area_entered(_area):
	set_state(MovementState.Damaged)
	timer.start()


func _on_DamageTimer_timeout():
	set_state(MovementState.Idle)
