extends Node2D

@onready var nave = $Game/nave

func _ready():
	TurnManager.turn_changed.connect(_turn_changed)

func _turn_changed(turn: int):
	if turn == TurnManager.phase.PLANNING:
		erase_all_lines()

func _physics_process(delta):
	if  TurnManager.turn_phase == TurnManager.phase.PLANNING:
		var mouse = get_global_mouse_position()
		
		if Input.is_action_just_pressed("click"):
			
			var default_map_rid: RID = get_world_2d().get_navigation_map()
			var path: PackedVector2Array = NavigationServer2D.map_get_path(
				default_map_rid,
				nave.global_position,
				mouse,
				true
			)
			nave.current_path = path
			nave.current_index = 0
			create_line(nave.global_position, mouse, nave.name)
			
		if Input.is_action_just_pressed("right"):
			var points : Array = nave.current_path
			if len(points) > 0:
				for i in range(points.size()-1):
					var dah_point = Geometry2D.get_closest_point_to_segment (mouse, points[i], points[i+1])
					if (dah_point.distance_to(mouse) <= 20):
						$Pointer.position = dah_point
						points.insert(i+1, dah_point)
						nave.current_path = points
						nave.current_index = 0
						break
		get_tree().paused = true
		
		$CanvasLayer/Control/Label.text = "planejamento"
	else:
		get_tree().paused = false
		
		$CanvasLayer/Control/Label.text = "luta!"

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

