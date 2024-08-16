extends Node2D

@onready var nave = $Game/nave

var selected: Node

func _ready():
	TurnManager.turn_changed.connect(_turn_changed)
	selected = nave

func _turn_changed(turn: int):
	if turn == TurnManager.phase.PLANNING:
		erase_all_lines()

func _physics_process(delta):
	if  TurnManager.turn_phase == TurnManager.phase.PLANNING:
		var mouse = get_global_mouse_position()
		
		if Input.is_action_just_pressed("click") and selected != null:
			
			var default_map_rid: RID = get_world_2d().get_navigation_map()
			var path: PackedVector2Array = NavigationServer2D.map_get_path(
				default_map_rid,
				selected.global_position,
				mouse,
				true
			)
			selected.current_path = path
			selected.current_index = 0
			selected.navigation_agent.target_position = path[0]
			create_line(selected.global_position, mouse, selected.name)
			selected = null
			
		if Input.is_action_just_pressed("right"):
			for _nave in $Game.get_children():
				if not "current_path" in _nave:
					continue
				var points : Array = _nave.current_path
				
				if len(points) > 0:
					for i in range(points.size()-1):
						var dah_point = Geometry2D.get_closest_point_to_segment(mouse, points[i], points[i+1])
						
						if dah_point.distance_to(mouse) <= 8: # ajustável
							if _nave.trigger_point:
								if _nave.trigger_point.distance_to(mouse) <= 12:  # ajustável
									break
							else:
								$Pointer.position = dah_point
								points.insert(i+1, dah_point)
								
								_nave.trigger_point = dah_point
								_nave.current_path = points
								_nave.current_index = 0
								spawn_action_popup(_nave.trigger_point, "%s-line" % _nave.name)
							break
		get_tree().paused = true
		
		$CanvasLayer/Control/Label.text = "planejamento"
	else:
		get_tree().paused = false
		
		$CanvasLayer/Control/Label.text = "luta!"

func spawn_action_popup(point, line_name):
	var popup : RadialMenuAdvanced = load("res://scenes/ui/action_popup.tscn").instantiate()
	popup.global_position = point
	$Lines.get_node(line_name).add_child(popup)
	

func erase_all_lines():
	var deleter: Callable = func(node): node.queue_free()
	$Lines.get_children().any(deleter)

func create_line(current_pos: Vector2, target_pos: Vector2, current_owner: String):
	var line_name = "%s-line" % current_owner
	if $Lines.has_node(line_name):
		$Lines.get_node(line_name).queue_free()
		await $Lines.get_node(line_name).tree_exited
		
	var new_line := Line2D.new()
	new_line.points = PackedVector2Array([current_pos, target_pos])
	new_line.name = line_name
	$Lines.add_child(new_line)
	pass
