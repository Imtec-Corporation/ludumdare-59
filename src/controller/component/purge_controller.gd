class_name PurgeController
extends Button

@export var clickSound: AudioStream
@export var hoverSound: AudioStream
@onready var clickPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	self.connect("pressed", self.on_purge_pressed)
	self.mouse_entered.connect(self._hover)

func _hover() -> void:
	clickPlayer.stream = hoverSound
	clickPlayer.play()

func on_purge_pressed() -> void:
	clickPlayer.stream = clickSound
	clickPlayer.play()

	AttackEvent.emit(false)