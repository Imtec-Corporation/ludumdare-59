extends Sprite3D

@export var viewPort: SubViewport
var _last_view_pos: Vector2

func _ready() -> void:
	viewPort.gui_disable_input = false
	viewPort.handle_input_locally = true
	_last_view_pos = viewPort.size * 0.5

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	
	var localPos = to_local(event_position)
	
	if event is InputEventMouse:
		var eventCopy = event.duplicate()
		
		var textSize = texture.get_size() * pixel_size
		
		var viewPos = Vector2()
		viewPos.x = (localPos.x / textSize.x + 0.5) * viewPort.size.x
		viewPos.y = (0.5 - localPos.y / textSize.y) * viewPort.size.y
		_last_view_pos = viewPos
		
		eventCopy.position = viewPos
		eventCopy.global_position = viewPos
		viewPort.push_input(eventCopy)

func _on_area_3d_mouse_entered() -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_push_left_release()

func _on_area_3d_mouse_exited() -> void:
	_push_left_release()


func _push_left_release() -> void:
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	release.button_mask = 0
	release.position = _last_view_pos
	release.global_position = _last_view_pos
	viewPort.push_input(release)
