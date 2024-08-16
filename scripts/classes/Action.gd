class_name Action
extends Node

# Define o sinal que será emitido quando a ação for concluída
signal finished

var action_callable: Callable
var action_name: String
var action_description: String
var cursor_sprite: Node2D
var aim_behavior: AimBehavior

func _init(_callable: Callable, _name: String, _description: String, _cursor_sprite: Node2D, _aim_behavior: AimBehavior, _owner: Node):
	action_callable = _callable
	action_name = _name
	action_description = _description
	cursor_sprite = _cursor_sprite
	aim_behavior = _aim_behavior
	cursor_sprite.visible = true
	aim_behavior.owner = _owner  


func process(delta: float):
	if aim_behavior != null:
		aim_behavior.update_aim(delta, self)

func finish_action():
	if aim_behavior != null:
		aim_behavior.end_aim(self)
	
	emit_signal("finished") 
