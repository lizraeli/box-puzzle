extends KinematicBody2D


onready var ray = $RayCast2D
onready var tween = $Tween
onready var move_direction = global.directions.left
var collided_with_player = false
var player

func try_direction(direction):
	var vector_position = direction * global.grid_size
	ray.cast_to = vector_position
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider = ray.get_collider()
		if "is_player" in collider:
			collided_with_player = true
			player = collider
			return true
		
	return !ray.is_colliding()

func update_move_direction():
	if try_direction(move_direction):
		return true
	
	if move_direction == global.directions.left:
		move_direction = global.directions.right	
	else:
		move_direction = global.directions.left

	if try_direction(move_direction):
		return true
	
	# nowhere to move
	return false
	
func move():
	var has_place_to_move = update_move_direction()
	if has_place_to_move:
		var vector_position = move_direction * global.grid_size
		tween.interpolate_property(
			self, 
			"position",
			self.position, 
			self.position + vector_position, 
			0.2,
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT
		)
		tween.start()
		if collided_with_player:
			player.lose()







func _on_Tween_tween_all_completed():
	pass # Replace with function body.
