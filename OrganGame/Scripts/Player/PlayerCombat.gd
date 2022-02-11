extends KinematicBody2D

onready var anim = $AnimatedSprite

var isInCombo = false
export var timeTillNextInput = 0.5
var time = 0

onready var hands = $Hands

var current_attack_index = 0

func _ready():
	time = timeTillNextInput 
	
func _process(delta):
	if not isInCombo:
		if Input.is_action_just_pressed("p1_attack_forward"):
			anim.play("SideAttack")
			anim.set_frame(0)
			isInCombo = true
			hands.handle_specific_collider_disabling(false, 0)
			current_attack_index = 0
		elif Input.is_action_just_pressed("p1_attack_up"):
			anim.play("UpAttack")
			anim.set_frame(0)
			isInCombo = true
			hands.handle_specific_collider_disabling(false, 1)
			current_attack_index = 1
	if isInCombo:
		time -= delta
		if time <= 0:
			time = timeTillNextInput
			isInCombo = false
			hands.handle_specific_collider_disabling(true, current_attack_index)

