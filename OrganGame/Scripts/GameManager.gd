extends Node

# default is kidney
var player : String = "res://Scenes/Players/Kidney.tscn"
var enemy : String = "res://Scenes/TestGetEnemyDuringAttack.tscn"

func set_player(location : String) -> void:
	player = location
func get_player() -> String:
	return player
	
func set_enemy(location : String) -> void:
	enemy = location
func get_enemy() -> String:
	return enemy
