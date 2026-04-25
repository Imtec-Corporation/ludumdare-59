class_name CameraController
extends Camera3D

@export var speed: float = 1.5
@export var zoom_speed: float = 5.0
@export var drag_sensitivity: float = 0.005
@export var invert_x: bool = true
@export var invert_y: bool = true

func _process(delta: float) -> void:
	var rot = speed * delta
	if Input.is_action_pressed("ui_left"):
		rotate_object_local(Vector3.BACK, rot)
	if Input.is_action_pressed("ui_right"):
		rotate_object_local(Vector3.FORWARD, rot)
	if Input.is_action_pressed("ui_up"):
		rotate_object_local(Vector3.RIGHT, rot)
	if Input.is_action_pressed("ui_down"):
		rotate_object_local(Vector3.LEFT, rot)
		
	if Input.is_action_just_pressed("zoom_in"):
		self.fov -= zoom_speed
	if Input.is_action_just_pressed("zoom_out"):
		self.fov += zoom_speed


func _unhandled_input(event: InputEvent) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		return

	if event is InputEventMouseMotion:
		var x_sign := -1.0 if invert_x else 1.0
		var y_sign := -1.0 if invert_y else 1.0
		var yaw: float = event.relative.x * drag_sensitivity * x_sign
		var pitch: float = event.relative.y * drag_sensitivity * y_sign
		rotate_object_local(Vector3.UP, yaw)
		rotate_object_local(Vector3.RIGHT, pitch)
