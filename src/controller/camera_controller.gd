class_name CameraController
extends Camera3D

@export var speed: float = 0.5

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_y(speed * delta)
	if Input.is_action_pressed("ui_right"):
		rotate_y(-speed * delta)
	if Input.is_action_pressed("ui_up"):
		rotate_x(speed * delta)
	if Input.is_action_pressed("ui_down"):
		rotate_x(-speed * delta)
