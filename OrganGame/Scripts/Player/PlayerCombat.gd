extends KinematicBody2D

onready var anim = $AnimatedSprite

var isInCombo = false
export var timeTillNextInput = 0.5
var time = 0

func _ready():
	time = timeTillNextInput 
	
func _process(delta):
	if not isInCombo:
		if Input.is_action_just_pressed("attack_forward"):
			anim.play("SideAttack")
			anim.set_frame(0)
			isInCombo = true
		elif Input.is_action_just_pressed("attack_up"):
			anim.play("UpAttack")
			anim.set_frame(0)
			isInCombo = true
	if isInCombo:
		time -= delta
		if time <= 0:
			time = timeTillNextInput
			isInCombo = false
