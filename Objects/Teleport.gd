extends Area2D

			
func _on_Spot_body_entered(body: Node):
	if body.has_method('start_teleport'):
		body.start_teleport(self.position)
			
func _on_Spot_body_exited(body: Node):
	if body.has_method('end_teleport'):
		body.end_teleport()
