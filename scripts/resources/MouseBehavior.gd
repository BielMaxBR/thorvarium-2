extends AimBehavior
class_name MouseAimBehavior

@export var cursor_texture: Texture2D

var cursor_sprite: TextureRect

func start_aim(action: Action):
	cursor_sprite = TextureRect.new()
	cursor_sprite.texture = cursor_texture
	owner.get_node("CanvasLayer").add_child(cursor_sprite)

func update_aim(delta: float, action: Action):
	if owner != null and cursor_sprite != null:
		cursor_sprite.position = owner.get_global_mouse_position()

func end_aim(action: Action):
	if cursor_sprite != null:
		cursor_sprite.visible = false
