extends Node

var player : String = "res://Scenes/PlayerMovement.tscn"
var enemy : String

func set_player(location : String) -> void:
	player = location
func get_player() -> String:
	return player
	
func set_enemy(location : String) -> void:
	enemy = location
func get_enemy() -> String:
	return enemy
