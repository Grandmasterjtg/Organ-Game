extends Node

# starting positions
export var p1_position = Vector2(200, 0)
export var p2_position = Vector2(800, 0)


func _ready():
	# connect signal form game manager to instantiate win screen on victory
	GameManager.connect("player_wins", self, "_on_player_wins")
	# game has started, game over is false
	GameManager.set_game_over(false)
	
	# create player 1
	var p1_character = load(GameManager.get_player(1)).instance()
	p1_character.position = p1_position
	add_child(p1_character)
	
	# create player 2
	var p2_character = load(GameManager.get_player(2)).instance()
	p2_character.position = p2_position
	add_child(p2_character)
	# start player 2 facing the right way
	p2_character.get_node("Animations").scale.x = -1
	
	# instantiate pause menu
	var pause = load("res://Scenes/UI/Pause.tscn").instance()
	add_child(pause)
	
	
func _on_player_wins():
	var game_over_screen = load("res://Scenes/UI/WinScreen.tscn").instance()
	add_child(game_over_screen)
	
