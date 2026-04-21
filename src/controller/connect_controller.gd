class_name ConnectController
extends Button

var station: Station

func _ready() -> void:
	self.text = "Connect"
	self.connect("pressed", self.on_connect_pressed)
	self.station = get_tree().root.get_node("Root").station as Station

func on_connect_pressed() -> void:
	if self.station.synced:
		DataEvent.emit()
	else:
		MessageEvent.emit("Data link not available", true)
