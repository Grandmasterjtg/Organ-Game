extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(ev):
	if ev.is_action_pressed("pause") and not GameManager.get_game_over():
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
