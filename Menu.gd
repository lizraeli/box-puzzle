extends Node2D

const Game = preload("res://Game.gd")
onready var start_label: Label = get_node("StartLabel")
onready var load_label: Label = get_node("LoadLabel")
onready var has_saved_game = global.has_saved_game()

func _ready():
	if has_saved_game:
		load_label.show()
	else:
		load_label.add_color_override(
			"font_color", Color(0.9, 0.9, 0.9, 0.9)
		)
	
func _on_StartArea_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton:
		get_tree().change_scene("res://Levels/Level1.tscn");	

func _on_LoadArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		global.load_game()
		
func highlight_label(label: Label):
	label.add_color_override(
		"font_color", Color8(250, 230, 15)
	)
		
func remove_highlight_label(label: Label):
	label.add_color_override(
		"font_color", Color(1, 1, 1)
	)

func _on_StartArea_mouse_entered():
	highlight_label(start_label)

func _on_StartArea_mouse_exited():
	remove_highlight_label(start_label)

func _on_LoadArea_mouse_entered():
	if has_saved_game:
		highlight_label(load_label)


func _on_LoadArea_mouse_exited():
	if has_saved_game:
		remove_highlight_label(load_label)
