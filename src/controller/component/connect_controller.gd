class_name ConnectController
extends Button

@export var clickSound: AudioStream
@export var hoverSound: AudioStream
@onready var clickPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

var synced: bool
var attacked: bool

func _ready() -> void:
	self.text = "Connect"
	self.connect("pressed", self.on_connect_pressed)
	SyncEvent.register(self._on_sync)
	synced = false
	attacked = false
	AttackEvent.register(self._on_attack_event)
	self.mouse_entered.connect(self._hover)

func _hover() -> void:
	clickPlayer.stream = hoverSound
	clickPlayer.play()

func on_connect_pressed() -> void:
	clickPlayer.stream = clickSound
	clickPlayer.play()

	if attacked:
		return

	if synced:
		DataEvent.emit()
	else:
		MessageEvent.emit("[ERROR]: Data link not available", true)
		
func _on_sync(s: bool) -> void:
	synced = s

func _on_attack_event(attack: bool) -> void:
	attacked = attack
