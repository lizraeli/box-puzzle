extends KinematicBody2D

const is_player = true
onready var ray = $RayCast2D
onready var tween = $Tween
var teleporting = false
var is_moving = false
var move_vector: Vector2
var move_direction: String
var lost = false


func _unhandled_input(event: InputEvent):
	if not get_parent().player_move:
		return

	if event is InputEventKey:
		match event.scancode:
			KEY_O:
				get_parent().get_node("ExitGate").open()
			KEY_M:
				global.goto_menu()

	if event.is_action_pressed("ui_wait"):
		get_parent().finish_player_move()	
		return

	if event.is_action_pressed("reset"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		return

	# handle movement
	for dir in global.directions.keys():
		if event.is_action_pressed("ui_" + dir):
			if not tween.is_active():
				move_direction = dir
				move(dir)

func move(dir: String) -> void:
	move_vector = global.directions[dir] * global.grid_size
	ray.cast_to = move_vector
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		move_player()
	else:
		if move_object(dir):
			move_player()

func grow(to_scale, seconds):
	tween.interpolate_property(
		self, 
		"scale", 
		self.scale, 
		to_scale, 
		seconds, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	tween.start()


func move_player() -> void:
	tween.interpolate_property(
		self, "position",
		self.position, 
		self.position + move_vector, 
		0.2,
		Tween.TRANS_SINE, 
		Tween.EASE_IN_OUT
	)

	tween.start()

func lose():
	yield(get_tree().create_timer(0.1), "timeout")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()	
	
func move_object(dir: String) -> bool:
	var collider = ray.get_collider()
	if typeof(collider) == TYPE_OBJECT:
		if collider.is_in_group('box'):
			return collider.move(dir)
		if 'is_open' in collider:
			return collider.is_open
		if collider.is_in_group('enemies'):
			lose()
			return true

	return false
	
func start_teleport(tel_position):
	if not teleporting:
		teleporting = true
		var next_tel_position = global.get_next_tel_position(tel_position)
		self.set_position(next_tel_position)
		move(move_direction)

func end_teleport():
	teleporting = false

func _on_Tween_tween_all_completed():
	get_parent().finish_player_move()	
	get_parent().check_completed()


