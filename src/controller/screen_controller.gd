extends Sprite3D

@export var viewPort: SubViewport

func _ready() -> void:
	viewPort.gui_disable_input = false
	viewPort.handle_input_locally = true

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var localPos = to_local(event_position)
	
	if event is InputEventMouse:
		var eventCopy = event.duplicate()
		
		var textSize = texture.get_size() * pixel_size
		
		var viewPos = Vector2()
		viewPos.x = (localPos.x / textSize.x + 0.5) * viewPort.size.x
		viewPos.y = (0.5 - localPos.y / textSize.y) * viewPort.size.y
		
		print_debug("3D Spot: ", position, " -> 2D Viewport Sport: ", viewPos)
		
		eventCopy.position = viewPos
		eventCopy.global_position = viewPos
		viewPort.push_input(eventCopy)
