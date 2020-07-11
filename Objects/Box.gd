extends KinematicBody2D

onready var ray = $RayCast2D
onready var activated_sprite = get_node("Sprite").get_node("Activated")
var move_direction: String
var teleporting = false

func move(dir: String) -> bool:
	move_direction = dir
	var vector_position = global.directions[dir] * global.grid_size
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

func _ready():
	activated_sprite.visible = false

func occupy_spot():
	activated_sprite.visible = true

func leave_spot():
	activated_sprite.visible = false

func start_teleport(tel_position):
	if not teleporting:
		teleporting = true
		var next_tel_position = global.get_next_tel_position(tel_position)
		self.set_position(next_tel_position)
		move(move_direction)

func end_teleport():
	teleporting = false
