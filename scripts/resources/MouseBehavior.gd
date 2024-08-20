extends AimBehavior
class_name MouseAimBehavior

@export var cursor_texture: Texture2D

var cursor_sprite: Sprite2D

func start_aim(action: Action):
	var canvas_layer: CanvasLayer = owner.get_node("CanvasLayer")
	assert(canvas_layer, "the owner need a CanvasLayer with this exact name for the UI")
	
	canvas_layer.follow_viewport_enabled = true
	cursor_sprite = Sprite2D.new()
	cursor_sprite.texture = cursor_texture
	owner.get_node("CanvasLayer").add_child(cursor_sprite)

func update_aim(delta: float, action: Action):
	if owner != null and cursor_sprite != null:
		cursor_sprite.global_position = owner.get_global_mouse_position()

func end_aim(action: Action):
	if cursor_sprite != null:
		cursor_sprite.visible = false
