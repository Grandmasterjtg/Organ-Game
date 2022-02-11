extends Node

# default is kidney
var player1 : String = "res://Scenes/Players/P1/Kidney.tscn"
var player2 : String = "res://Scenes/Players/P2/P2_Kidney.tscn"

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
