extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var trigger_point: Vector2
var current_index: int = 0
var current_path: PackedVector2Array

@export var mouse_aim: MouseAimBehavior

func _physics_process(delta):
	manage_line()
	move_using_navigation()

func _on_navigation_agent_2d_waypoint_reached(details):
	if details.position.round() == trigger_point.round():
		print("trigou!")

func move_to_position(action: Action):
	if Input.is_action_just_pressed("click"):
		create_path(global_position, get_global_mouse_position())
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
		erase_all_lines()
		ActionManager.set_action(action)

func move_using_navigation():
	if TurnManager.turn_phase == TurnManager.phase.PLANNING: return
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

func manage_line():
	if ActionManager.current_action != null: return
	
	var points = current_path
	var mouse = get_global_mouse_position()

	if len(points) > 0:
		for i in range(points.size()-1):
			var inline_point = Geometry2D.get_closest_point_to_segment(mouse, points[i], points[i+1])
			
			if inline_point.distance_to(mouse) <= 8: # ajustável
				if not trigger_point in points:
					set_pointer(inline_point)
					#spawn_action_popup(trigger_point)
				else:
					if trigger_point.distance_to(mouse) <= 12:  # ajustável
						break
					
				if Input.is_action_just_pressed("click"):
					set_pointer(inline_point)
					points.insert(i+1, inline_point)
					print("ponto feito")
					
					trigger_point = inline_point
					current_path = points
					current_index = 0
				
				break

func set_pointer(point: Vector2):
	var pointer : Sprite2D
	if not $CanvasLayer.has_node("Pointer"):
		pointer = load("res://scenes/ui/pointer.tscn").instantiate()
		$CanvasLayer.add_child(pointer)
	else:
		pointer = $CanvasLayer.get_node("Pointer")
	pointer.global_position = point

func create_path(current_pos: Vector2, target_pos: Vector2):
	var default_map_rid: RID = get_world_2d().get_navigation_map()
	var path: PackedVector2Array = NavigationServer2D.map_get_path(
		default_map_rid,
		current_pos,
		target_pos,
		false
	)
	current_path = path
	current_index = 0
	navigation_agent.target_position = path[0]
	create_line(current_pos, target_pos)

func create_line(current_pos: Vector2, target_pos: Vector2):
	var new_line := Line2D.new()
	new_line.points = PackedVector2Array([current_pos, target_pos])
	$CanvasLayer.add_child(new_line)
	pass

func erase_all_lines():
	var deleter: Callable = func(node): node.queue_free()
	$CanvasLayer.get_children().any(deleter)
