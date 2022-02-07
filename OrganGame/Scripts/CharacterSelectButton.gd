extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var character : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if character == "":
		print("Character name cannot be empty")
	
func _pressed():
	GameManager.set_player(character)
	get_tree().change_scene("res://Levels/TestLevel.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
