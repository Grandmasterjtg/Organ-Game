extends KinematicBody2D

# state variables
enum PlayerState { Idle, Walking, Jumping, Attacking, Damaged }
var current_state = PlayerState.Idle

# movement variables
const UP_DIRECTION = Vector2.UP
export var speed := 30000.0
export var air_speed := 3000.0
export var max_speed := 550.0
var velocity := Vector2.ZERO

# jump variables
export var jump_strength := 1500.0
export var gravity := 4500.0

# combat variables
export var attack_cooldown := 1.0
var attack_time := 0.0
export var damage_reaction = Vector2(100, -1000)
onready var timer = $DamageTimer

# animation variables
onready var anim := $Animations/AnimatedSprite

func _ready():
	attack_time = attack_cooldown
	set_current_state(PlayerState.Idle)
	
func _process(delta):
	if current_state != PlayerState.Damaged:
		if current_state != PlayerState.Attacking:
			if Input.is_action_just_pressed("attack_forward"):
				attack("SideAttack")
			elif Input.is_action_just_pressed("attack_up"):
				attack("UpAttack")
		else:
			attack_time -= delta
			if attack_time <= 0:
				set_current_state(PlayerState.Idle)
				
func _physics_process(delta):
	# have the character be affected by gravity
	velocity.y += gravity * delta
	
	if current_state != PlayerState.Damaged and current_state != PlayerState.Attacking:
		# gets horizontal direction based on player input
		var horizontal_direction = (
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))

#		# sets velocity based on player input
#		# ground velocity
		if is_on_floor():
			velocity.x = horizontal_direction * speed * delta
		# air speed
		else:
			velocity.x += horizontal_direction * air_speed * delta
			velocity.x = clamp(velocity.x, -max_speed, max_speed)


		# check for player input
		# jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			set_current_state(PlayerState.Jumping)
		# jump cancelled
		elif Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
		# walking
		elif not is_zero_approx(velocity.x) and is_on_floor():
			set_current_state(PlayerState.Walking)
		# idle
		elif is_zero_approx(velocity.x) and is_on_floor():
			set_current_state(PlayerState.Idle)

		if horizontal_direction < 0:
			anim.get_parent().scale.x = -1
		elif horizontal_direction > 0:
			anim.get_parent().scale.x = 1
	
	# moves the player
	velocity = move_and_slide(velocity, UP_DIRECTION)

func attack(anim_name : String) -> void:
	attack_time = attack_cooldown
	anim.play(anim_name)
	anim.set_frame(0)
	set_current_state(PlayerState.Attacking)
	
# setter for the velocity variable
func set_velocity(new_velocity : Vector2) -> void:
	velocity = new_velocity
# modifies velocity variable by adding mod_velcoity to it
func change_velocity(mod_velocity : Vector2) -> void:
	velocity += mod_velocity
	
func set_current_state(new_state) -> void:
	current_state = new_state
	handle_state_change()
func handle_state_change() -> void:
	match current_state:
		PlayerState.Attacking:
			velocity.x = 0
		PlayerState.Jumping:
			velocity.y = -jump_strength
			anim.play("JumpFull")
		PlayerState.Walking:
			anim.play("Walk")
		PlayerState.Idle:
			anim.play("Idle")
		PlayerState.Damaged:
			anim.play("Damage")
			anim.set_frame(0)
			timer.start()


func _on_HurtBox_area_entered(area : Area2D) -> void:
	set_current_state(PlayerState.Damaged)
	var direction = position.x - area.position.x
	if direction >= 0:
		velocity = damage_reaction
	else:
		velocity = Vector2(damage_reaction.x * -1, damage_reaction.y)


func _on_DamageTimer_timeout() -> void:
	set_current_state(PlayerState.Idle)
	timer.stop()
	print("time")
