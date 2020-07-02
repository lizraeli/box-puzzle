extends KinematicBody2D

var is_open = false

func _ready():
	get_node("ClosedGate").visible = true
	get_node("OpenGate").visible = false
	
func open():
	is_open = true
	get_node("ClosedGate").visible = false
	get_node("OpenGate").visible = true
