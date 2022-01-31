extends KinematicBody2D


var velocity = Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_just_pressed:
		react_to_damage()

func react_to_damage():
	pass
