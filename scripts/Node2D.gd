extends Node2D

@onready var nave = $Game/nave

var selected: Node

func _ready():
	TurnManager.turn_changed.connect(_turn_changed)
	selected = nave

func _turn_changed(turn: int):
	if turn == TurnManager.phase.PLANNING:
		#erase_all_lines()
		pass

func _physics_process(delta):
	if  TurnManager.turn_phase == TurnManager.phase.PLANNING:
		$CanvasLayer/Control/Label.text = "planejamento"
	else:
		$CanvasLayer/Control/Label.text = "luta!"

func spawn_action_popup(point, line_name):
	var popup : RadialMenuAdvanced = load("res://scenes/ui/action_popup.tscn").instantiate()
	popup.global_position = point
	$Lines.get_node(line_name).add_child(popup)
	
#
