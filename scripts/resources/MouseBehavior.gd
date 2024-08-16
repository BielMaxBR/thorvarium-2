extends AimBehavior
class_name MouseAimBehavior

var owner: Node

# Atualiza o sprite de mira para seguir o mouse
func update_aim(delta: float, action: Action):
	if owner != null and action.cursor_sprite != null:
		action.cursor_sprite.position = owner.get_global_mouse_position()  # Usa o node owner para acessar a posição do mouse

# Esconde o sprite de mira quando a ação termina
func end_aim(action: Action):
	if action.cursor_sprite != null:
		action.cursor_sprite.visible = false
