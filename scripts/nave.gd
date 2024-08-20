extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var trigger_point: Vector2
var current_index: int = 0
var current_path: PackedVector2Array

@export var mouse_aim: MouseAimBehavior

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if current_index+1 < len(current_path):
			current_index += 1
			navigation_agent.target_position = current_path[current_index]
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	navigation_agent.velocity = velocity
	move_and_slide()


func _on_navigation_agent_2d_waypoint_reached(details):
	if details.position.round() == trigger_point.round():
		print("trigou!")

func move_to_position(action: Action):
	if Input.is_action_just_pressed("click"):
		print(action.action_name, get_global_mouse_position())
		action.finish_action()

func _on_selector_input_event(viewport: Node, _event: InputEvent, shape_idx: int) -> void:
	if _event is not InputEventMouseButton: return
	var event: InputEventMouseButton = _event
	if Input.is_action_just_released("click"):
		var action = Action.new(
			Callable(self, "move_to_position"),
			"Mover Player",
			"Move o player para a posição clicada.",
			mouse_aim,
			self
		)
		print("action declarada")
		ActionManager.set_action(action)
