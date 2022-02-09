extends Node

export var p1_position = Vector2(200, 0)
export var p2_position = Vector2(500, 400)


func _ready():
	# create the player
	var p1_character = load(GameManager.get_player()).instance()
	p1_character.position = p1_position
	add_child(p1_character)
	
	var p2_character = load(GameManager.get_enemy()).instance()
	p2_character.position = p2_position
	add_child(p2_character)
	
	var pause = load("res://Scenes/UI/Pause.tscn").instance()
	add_child(pause)
	
