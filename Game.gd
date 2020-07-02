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
	if global.level < 4:
		global.level += 1
		var next_scene = "res://Levels/Level%s.tscn" % global.level
		get_tree().change_scene(next_scene);	
	else:
		get_node("UI/WinDialog").popup()
				
func _on_AcceptDialog_confirmed():
	goto_next_level()
