extends KinematicBody2D

onready var ray = $RayCast2D
onready var tween = $Tween
const is_player = true
var teleporting = false
var is_moving = false
var move_vector: Vector2
var move_direction: String

func _unhandled_input(event: InputEvent):
	if event is InputEventKey:
		match event.scancode:
			KEY_O:
				get_parent().get_node("ExitGate").open()
			KEY_M:
				global.goto_menu()

	if event.is_action_pressed("reset"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		return

	# handle movement
	for dir in global.inputs.keys():
		if event.is_action_pressed(dir):
			if not tween.is_active():
				move_direction = dir
				move(dir)

func move(dir: String) -> void:		
	move_vector = global.inputs[dir] * global.grid_size
	ray.cast_to = move_vector
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		move_player()
	else:
		if move_object(dir):
			move_player()

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
	get_parent().moves += 1

func move_object(dir: String) -> bool:
	var collider = ray.get_collider()
	if typeof(collider) == TYPE_OBJECT:
		if collider.is_in_group('box'):
			return collider.move(dir)
		if 'is_open' in collider:
			return collider.is_open

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
	get_parent().check_completed()
