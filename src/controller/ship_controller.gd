class_name ShipController
extends Node3D

var rotationSpeed: Vector3

func _init() -> void:
	rotationSpeed = Vector3(randf_range(0, 0.1), randf_range(0, 0.1), randf_range(0, 0.1))
	
func _process(delta: float) -> void:
	rotate_x(rotationSpeed.x * delta)
	rotate_y(rotationSpeed.y * delta)
	rotate_z(rotationSpeed.z * delta)
