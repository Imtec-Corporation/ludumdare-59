class_name ConnectController
extends Button

var synced: bool

func _ready() -> void:
	self.text = "Connect"
	self.connect("pressed", self.on_connect_pressed)
	SyncEvent.register(self._on_sync)
	synced = false

func on_connect_pressed() -> void:
	if synced:
		DataEvent.emit()
	else:
		MessageEvent.emit("Data link not available", true)
		
func _on_sync(s: bool) -> void:
	synced = s
