extends Node2D

func _physics_process(delta):
	if  TurnManager.turn_phase == TurnManager.phase.PLANNING:
		if Input.is_action_just_pressed("click"):
			$Game/nave.navigation_agent.target_position = get_global_mouse_position()
		get_tree().paused = true
		
		$CanvasLayer/Control/Label.text = "planejamento"
	else:
		get_tree().paused = false
		
		$CanvasLayer/Control/Label.text = "luta!"
