extends KinematicBody2D

onready var ray = $RayCast2D

func move(dir: String) -> bool:
	var vector_position = global.inputs[dir] * global.grid_size
	ray.cast_to = vector_position
	ray.force_raycast_update()
	if !ray.is_colliding():
		$Tween.interpolate_property(
			self, 
			"position",
			self.position, 
			self.position + vector_position, 
			0.2,
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT
		)
		$Tween.start()
		return true
		
	return false



func _on_Tween_tween_started(object, key):
	pass # Replace with function body.
