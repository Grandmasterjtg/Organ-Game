extends Control

onready var player_label := $WinningPlayer
onready var button_display := $VButtonContainer
onready var timer = $Timer

func _ready():
	player_label.text = "Player " + str(GameManager.get_winning_player()) + " Wins"
	timer.start()


func _on_Timer_timeout():
	button_display.visible = true
