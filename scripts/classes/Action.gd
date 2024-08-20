class_name Action
extends Node

# Define o sinal que será emitido quando a ação for concluída
signal finished

var action_callable: Callable
var action_name: String
var action_description: String
var aim_behavior: AimBehavior

var is_active := false

func _init(_callable: Callable, _name: String, _description: String, _aim_behavior: AimBehavior, _owner: Node):
	action_callable = _callable
	action_name = _name
	action_description = _description
	aim_behavior = _aim_behavior
	aim_behavior.owner = _owner  

func _ready():
	is_active = true
	aim_behavior.start_aim(self)

func _process(delta: float):
	if is_active:
		action_callable.call(self)
		if aim_behavior != null:
			aim_behavior.update_aim(delta, self)

func finish_action():
	is_active = false
	if aim_behavior != null:
		aim_behavior.end_aim(self)
	
	emit_signal("finished") 
