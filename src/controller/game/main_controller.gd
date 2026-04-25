class_name MainController
extends Node3D

@export var titleCam: Camera3D
@export var stationCam: Camera3D
@export var station: Node3D

@onready var titleUi: Control = $TitleUI
@onready var bgm: AudioStreamPlayer2D = $BGM

func _ready() -> void:
	GameStartEvent.register(self._on_game_start)
	GameOverEvent.register(self._on_game_over)

func _process(_delta: float) -> void:
	self.titleCam.look_at(self.station.global_position)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_game_start() -> void:
	titleUi.visible = false
	bgm.stop()
	self.stationCam.make_current()

func _on_game_over() -> void:
	GameOverEvent.unregister(self._on_game_over)
	GameStartEvent.unregister(self._on_game_start)
