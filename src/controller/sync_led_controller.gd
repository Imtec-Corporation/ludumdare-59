class_name SyncLedController
extends ColorRect

@export var syncColor: Color = Color.GREEN
@export var desyncColor: Color = Color.RED

func _ready() -> void:
	SyncEvent.register(self._on_sync)

func _on_sync(sync: bool) -> void:
	if sync:
		self.color = syncColor
	else:
		self.color = desyncColor
