extends Area2D

func _on_exit_stairs_body_entered(body):
	if 'is_player' in body:
		get_parent().goto_next_level()


