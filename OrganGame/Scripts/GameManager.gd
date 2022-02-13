extends Node

signal player_wins()

# default is kidney
var player1 : String = "res://Scenes/Players/P1/Kidney.tscn"
var player2 : String = "res://Scenes/Players/P2/P2_Kidney.tscn"

var game_over := false
var winning_player_number := 0

func set_player(playerNum : int, location : String) -> void:
	if playerNum == 1:
		player1 = location
	if playerNum == 2:
		player2 = location
func get_player(playerNum : int) -> String:
	if playerNum == 1:
		return player1
	elif playerNum == 2:
		return player2
	else:
		return ""
		
func set_game_over(is_game_over : bool) -> void:
	game_over = is_game_over
func get_game_over() -> bool:
	return game_over
	
# sets the winning player and set the state to game over
func set_winning_player(player_number : int) -> void:
	winning_player_number = player_number
	set_game_over(true)
	emit_signal("player_wins")
func get_winning_player() -> int:
	return winning_player_number
