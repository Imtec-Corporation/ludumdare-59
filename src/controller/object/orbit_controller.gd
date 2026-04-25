class_name OrbitController
extends Node3D

@export var speed: float = 0.1

func _process(delta: float) -> void:
	rotate_x(speed * delta)
