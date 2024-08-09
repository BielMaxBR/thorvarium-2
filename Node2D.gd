extends Node2D

func _physics_process(delta):
	if  TurnManager.turn_phase == TurnManager.phase.PLANNING:
		var mouse = get_global_mouse_position()
		if Input.is_action_just_pressed("click"):
			$Game/nave.navigation_agent.target_position = mouse
			$Game/nave.navigation_agent.get_next_path_position()
			
		if Input.is_action_just_pressed("right"):
			var points = $Game/nave.navigation_agent.get_current_navigation_path()
			if len(points) > 0:
				var dah_point = Geometry2D.get_closest_point_to_segment (mouse, points[0], points[1])
				
				$Pointer.position = dah_point
		get_tree().paused = true
		
		$CanvasLayer/Control/Label.text = "planejamento"
	else:
		get_tree().paused = false
		
		$CanvasLayer/Control/Label.text = "luta!"
