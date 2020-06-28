extends Area2D

var occupied = false


func _on_Spot_body_entered(body: Node):
	if body.is_in_group('box'):
		occupied = true


func _on_Spot_body_exited(body: Node):
	if body.is_in_group('box'):
		occupied = false
