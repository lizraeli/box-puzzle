extends Node2D

var level_complete = false
var moves = 0
onready var exit_gate = get_node("ExitGate")

func set_level_label(level: int):
	get_node("UI/NameLabel").text = 'Level ' + str(level)	

func _ready():
	set_level_label(global.level)
	global.init_teleport_list()

func _process(_delta):
	get_node("UI/MovesLabel").text = 'Moves: ' + str(moves)
	
func check_completed():
	if not level_complete:
		var unoccupied_spots = $Spots.get_child_count()
		for spot in $Spots.get_children():
			if spot.occupied:
				unoccupied_spots -= 1
	
		if unoccupied_spots == 0:
			level_complete = true 	
			if exit_gate:
				exit_gate.open()
			

func goto_next_level():
	if global.level < 5:
		global.goto_next_level()
	else:
		var win_dialog = get_node("UI/WinDialog")
		get_node("Player").visible = false
		get_node("UI/WinDialog").popup()
		
func _on_AcceptDialog_confirmed():
	global.goto_next_level()


func _on_WinDialog_confirmed():
	global.goto_menu()


func _on_GotoMenuArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		global.goto_menu()


func _on_GotoMenuArea_mouse_entered():
	get_node("UI/GotoMenuLabel").add_color_override(
		"font_color", Color8(250, 230, 15)
	)


func _on_GotoMenuArea_mouse_exited():
	get_node("UI/GotoMenuLabel").add_color_override(
		"font_color", Color(1, 1, 1)
	)
