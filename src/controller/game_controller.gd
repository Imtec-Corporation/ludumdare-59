class_name GameController 
extends Node

var station: Station

@onready var satLabel: Label = $UI/DataRow/SatNameLabel
@onready var coordLabel: Label = $UI/DataRow/SatCoordLabel
@onready var dataLabel: Label = $UI/DataRow/DataLabel
@onready var display: DisplayController = $UI/Display
@onready var syncTimer: Timer = $SyncTimer
@onready var syncProgress: ProgressBar = $UI/SyncProgress

var gameStarted: bool = false

var _is_reloading: bool = false

func _init() -> void:
	self.station = Station.new()

func _ready() -> void:
	DataEvent.register(self._on_data_received)
	GameOverEvent.register(self._on_game_over)
	GameStartEvent.register(self._on_game_start)

func _on_data_received(_int) -> void:
	if self.station.synced:
		self.syncTimer.stop()
		self.station.reset()
		self.syncTimer.start()
		ResetEvent.emit()

func _process(_float) -> void:
	if not self.gameStarted:
		return

	display.update_signals(self.station.satSignal, self.station.satellite.satSignal)
	self.station.update()
	self.syncProgress.value = (syncTimer.time_left / syncTimer.wait_time) * 100
	writeData()

func writeData() -> void:
	self.satLabel.text = "SAT: " + self.station.satellite.name
	self.coordLabel.text = "COORD: " + self.station.satellite.coordinates
	self.dataLabel.text = "DATA: " + str(self.station.data) + "MB"

func _on_game_start() -> void:
	self.gameStarted = true
	call_deferred("_emit_startup_message")
	self.station.reset()
	self.syncTimer.start()
	writeData()

func _on_sync_timer_timeout() -> void:
	MessageEvent.emit("Satellite reference lost", true)
	DataLossEvent.emit()
	self.station.reset()


func _emit_startup_message() -> void:
	MessageEvent.emit("System initialization complete")
	self.station.reset()

func _on_game_over() -> void:
	if _is_reloading:
		return
	_is_reloading = true
	gameStarted = false

	DataEvent.unregister(self._on_data_received)
	syncTimer.stop()
	$UI.visible = false
	$LoseLabel.visible = true

	var resetTimer: Timer = Timer.new()
	resetTimer.wait_time = 5.0
	resetTimer.one_shot = true
	resetTimer.name = "GameOverResetTimer"
	resetTimer.timeout.connect(self._on_reset_timer_timeout)
	add_child(resetTimer)
	resetTimer.start()

func _on_reset_timer_timeout() -> void:
	_stop_local_timers()
	get_tree().reload_current_scene()

func _stop_local_timers() -> void:
	for child in get_children():
		if child is Timer:
			var timer := child as Timer
			timer.stop()
			if timer != syncTimer:
				timer.queue_free()
