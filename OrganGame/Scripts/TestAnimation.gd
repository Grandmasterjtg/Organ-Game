extends KinematicBody2D

onready var anim = get_node("AnimatedSprite")

func _process(delta):
	if Input.is_key_pressed(KEY_K):
		test_match(1)
	if Input.is_key_pressed(KEY_L):
		test_match(2)
		
func test_match(x):
	match x:
		1:
			anim.play("Idle")
			print("1")
		2:
			anim.play("Walk")
			print("2")
