extends Node

var current_action: Action = null

func set_action(action: Action):
	if current_action != null:
		current_action.finished.disconnect(_on_action_finished)
	
	current_action = action
	current_action.finished.connect(_on_action_finished)
	
	add_child(current_action)  

func _on_action_finished():
	if current_action != null:
		current_action.queue_free()
		current_action = null
