class_name StartButtonController
extends Button

@export var clickSound: AudioStream
@export var hoverSound: AudioStream
@onready var clickPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	self.pressed.connect(self._on_pressed)
	self.mouse_entered.connect(self._hover)

func _hover() -> void:
	clickPlayer.stream = hoverSound
	clickPlayer.play()

func _on_pressed() -> void:
	clickPlayer.stream = clickSound
	clickPlayer.play()
	GameStartEvent.emit()