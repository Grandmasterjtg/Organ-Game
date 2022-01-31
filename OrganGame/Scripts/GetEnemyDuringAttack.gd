extends Area2D


func _on_TestGetEnemyDuringAttack_body_entered(body: PhysicsBody2D)->void:
	body.get_node(".").get_script().change_velocity(Vector2(-200, -1000))
