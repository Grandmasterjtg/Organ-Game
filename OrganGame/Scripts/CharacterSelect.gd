extends CheckBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var playerNum : int
export var characterName : String

# Called when the node enters the scene tree for the first time.
func _ready():
	if pressed:
		GameManager.set_player(playerNum, characterName)

func _pressed():
	GameManager.set_player(playerNum, characterName)
	print(GameManager.get_player(playerNum))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
