extends Node

const grid_size = 16
const inputs = {
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
	"ui_right": Vector2.RIGHT
}

var level = 1
var teleport_0_index = 0
var teleport_1_index = 0
var teleport_list = []
var used_teleport: Teleport

class Teleport:
	var node: Area2D
	var next: Teleport
	
	func _init(node: Area2D):
		self.node = node
		
func init_teleport_list():	
	teleport_list = []
	used_teleport = null
	var teleport_nodes = (
		get_tree().get_nodes_in_group("teleport")
	)
	if teleport_nodes:
		for teleport_node in teleport_nodes:
			teleport_list.append(
				Teleport.new(teleport_node)
			)
			
		for index in len(teleport_list):
			var teleport = teleport_list[index]
			var next_teleport_index: int
			if index % 2 == 0:
				# even-indexed teleports go forward
				next_teleport_index = index + 1
			else:
				# odd-indexed teleports go back
				next_teleport_index = index - 1
			
			teleport.next = teleport_list[next_teleport_index]
				
func get_next_tel_position(tel_position: Vector2):
	var goto_tel: Teleport
	
	for teleport in teleport_list:
		if teleport.node.position == tel_position:
			goto_tel = teleport.next

	return goto_tel.node.position
