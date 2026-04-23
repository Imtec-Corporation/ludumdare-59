class_name PurgeController
extends Button

func _ready() -> void:
	self.connect("pressed", self.on_purge_pressed)

func on_purge_pressed() -> void:
	AttackEvent.emit(false)