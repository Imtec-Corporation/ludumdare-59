class_name ConnectController
extends Button

var synced: bool
var attacked: bool

func _ready() -> void:
	self.text = "Connect"
	self.connect("pressed", self.on_connect_pressed)
	SyncEvent.register(self._on_sync)
	synced = false
	attacked = false
	AttackEvent.register(self._on_attack_event)

func on_connect_pressed() -> void:
	if attacked:
		return
		
	if synced:
		DataEvent.emit()
	else:
		MessageEvent.emit("Data link not available", true)
		
func _on_sync(s: bool) -> void:
	synced = s

func _on_attack_event(attack: bool) -> void:
	attacked = attack
