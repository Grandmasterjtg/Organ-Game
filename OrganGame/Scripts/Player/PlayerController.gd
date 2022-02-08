extends Node

enum PlayerState { Idle, Walking, Jumping, Damaged }
var current_state = PlayerState.Idle

# Movement Variables
export var speed := 600.0
export var in_air_speed := 50.0
export var max_speed_offset := 50.0
var velocity := Vector2.ZERO

# Jump Variables
export var jump_strength := 2000.0
export var gravity := 4500.0

# animation variables
onready var anim := $AnimatedSprite

# damage variables
onready var timer := $DamageTimer

func _ready():
	pass# set_state(MovementState.Idle)
	
func _physics_process(delta):
	velocity.y += gravity * delta
	
	match current_state:
		PlayerState.Idle:
			pass
	

# sets the velocity
func set_velocity(new_velocity : Vector2) -> void:
	velocity = new_velocity
# adds the Vector2 argument to the velocity variable
func change_velocity(mod_velocity : Vector2) -> void:
	velocity += mod_velocity

# sets the current state and calls the handle state function
func set_state(new_state) -> void:
	current_state = new_state
	handle_state_change()
# determines the logic during a state change
func handle_state_change() -> void:
	match current_state:
		PlayerState.Jumping:
			set_velocity(Vector2(velocity.x, -jump_strength))
			anim.play("JumpFull")
		PlayerState.Walking:
			anim.play("Walk")
		PlayerState.Idle:
			anim.play("Idle")
		PlayerState.Damaged:
			anim.play("Damaged")
			anim.set_frame(0)
