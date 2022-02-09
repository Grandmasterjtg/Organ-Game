extends Node


func _ready():
	var player_character = load(GameManager.get_player()).instance()
	player_character.position = Vector2(100, 0)
	add_child(player_character)
