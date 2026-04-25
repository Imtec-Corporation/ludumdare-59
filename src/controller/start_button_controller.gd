class_name StartButtonController
extends Button

func _ready() -> void:
	self.pressed.connect(self._on_pressed)

func _on_pressed() -> void:
	GameStartEvent.emit()