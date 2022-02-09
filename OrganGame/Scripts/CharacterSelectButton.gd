extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var character : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _pressed():
	if character != "":
		GameManager.set_player(character)
	get_tree().change_scene("res://Levels/TestLevel.tscn")
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
