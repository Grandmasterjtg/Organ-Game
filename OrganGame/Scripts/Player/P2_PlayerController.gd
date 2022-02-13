extends KinematicBody2D

# state variables
enum PlayerState { Idle, Walking, Jumping, Attacking, Damaged, Down }
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
export var attack_cooldown := 0.667
var attack_time := 0.0
export var damage_reaction := Vector2(200, -1000)
onready var damage_timer := $DamageTimer
onready var attack_timer := $AttackTimer
onready var health_bar := get_node("../P2HealthBar/ProgressBar")
onready var hands := $Animations/Hands
var current_attack_index := 0

# health variables
export var health := 100.0
export var damage := 10.0

# animation variables
onready var anim := $Animations/AnimatedSprite

func _ready():
	attack_time = attack_cooldown
	set_current_state(PlayerState.Idle)
	
func _process(delta):
	# player is disabled when down
	if current_state != PlayerState.Down:
		# can't attack in damaged state
		if current_state != PlayerState.Damaged:
			# can't attack while attacking
			if current_state != PlayerState.Attacking:
				if Input.is_action_just_pressed("p2_attack_forward"):
					attack("SideAttack")
					current_attack_index = 0
				elif Input.is_action_just_pressed("p2_attack_up"):
					attack("UpAttack")
					current_attack_index = 1
					
			# limits attack spamming
			else:
				attack_time -= delta
				if attack_time <= 0:
					set_current_state(PlayerState.Idle)
					hands.handle_specific_collider_disabling(true, current_attack_index)
					
		# if player has been defeated
		if health <= 0 or position.y > 650:
			set_current_state(PlayerState.Down)
				
func _physics_process(delta):
	# have the character be affected by gravity
	velocity.y += gravity * delta
	
	# stops ground movement when attacking
	if current_state == PlayerState.Attacking and is_on_floor():
		velocity.x = 0
	
	# disables movement when player is damaged, attacking, or down
	if current_state != PlayerState.Damaged and current_state != PlayerState.Attacking and current_state != PlayerState.Down:
		# gets horizontal direction based on player input
		var horizontal_direction = (
			Input.get_action_strength("p2_move_right") - Input.get_action_strength("p2_move_left"))

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
		if Input.is_action_just_pressed("p2_jump") and is_on_floor() and current_state != PlayerState.Jumping:
			set_current_state(PlayerState.Jumping)
		# jump cancelled
		elif Input.is_action_just_released("p2_jump") and velocity.y < 0:
			velocity.y = 0
		# walking
		elif not is_zero_approx(velocity.x) and is_on_floor() and current_state != PlayerState.Walking:
			set_current_state(PlayerState.Walking)
		# idle
		elif is_zero_approx(velocity.x) and is_on_floor() and current_state != PlayerState.Idle:
			set_current_state(PlayerState.Idle)

		if horizontal_direction < 0:
			anim.get_parent().scale.x = -1
		elif horizontal_direction > 0:
			anim.get_parent().scale.x = 1
	
	# moves the player
	velocity = move_and_slide(velocity, UP_DIRECTION)

# logic for attacking
func attack(anim_name : String) -> void:
	attack_time = attack_cooldown
	anim.play(anim_name)
	anim.set_frame(0)
	set_current_state(PlayerState.Attacking)
	attack_timer.start()
	
# setter for the velocity variable
func set_velocity(new_velocity : Vector2) -> void:
	velocity = new_velocity
# modifies velocity variable by adding mod_velcoity to it
func change_velocity(mod_velocity : Vector2) -> void:
	velocity += mod_velocity

# setter for current_state and calls the handle state function
func set_current_state(new_state) -> void:
	current_state = new_state
	handle_state_change()
# handles logic during a state change
func handle_state_change() -> void:
	match current_state:
		PlayerState.Jumping:
			velocity.y = -jump_strength
			anim.play("JumpFull")
		PlayerState.Walking:
			anim.play("Walk")
		PlayerState.Idle:
			anim.play("Idle")
		PlayerState.Damaged:
			health -= damage
			if health_bar:
				health_bar.update_progress_bar(health)
			# if the player is not defeated
			if health > 0:
				anim.play("Damage")
				anim.set_frame(0)
				damage_timer.start()
		PlayerState.Down:
			anim.play("Down")
			velocity = Vector2.ZERO
			# disables hurtbox so the player can't take damage after defeat
			get_node("HurtBox/CollisionShape2D").set_disabled(true)
			# player 2 lost, player 1 won
			GameManager.set_winning_player(1)

# when the player is hit
func _on_HurtBox_area_entered(area : Area2D) -> void:
	# if the attack came from a different character
	if self != area.owner:
		set_current_state(PlayerState.Damaged)
		
		# direction form attack to character
		var direction = global_position.x - area.global_position.x
		# if the hit came from the left
		if direction >= 0:
			velocity = damage_reaction
		# if the hit came from the right
		else:
			velocity = Vector2(damage_reaction.x * -1, damage_reaction.y)
		# disables players fist after attack lands
		area.get_child(0).call_deferred("set_disabled", true)


func _on_DamageTimer_timeout() -> void:
	set_current_state(PlayerState.Idle)
	damage_timer.stop()
	
	
func get_health() -> float:
	return health


func _on_AttackTimer_timeout():
	hands.handle_specific_collider_disabling(false, current_attack_index)
	attack_timer.stop()
