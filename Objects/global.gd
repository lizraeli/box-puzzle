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

func save():
	var save_dict = {
		"level": global.level
	}
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	# Store the save dictionary as a new line in the save file
	save_game.store_line(to_json(save_dict))
	save_game.close()

func goto_level(level: int):
	var next_scene = "res://Levels/Level%s.tscn" % level
	get_tree().change_scene(next_scene)

func goto_menu():
	level = 1
	get_tree().change_scene("res://Menu.tscn")
			
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.	
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# Now we set the remaining variables.
		for key in node_data.keys():
			if key == "level":
				level = node_data[key]
		
		goto_level(level)
