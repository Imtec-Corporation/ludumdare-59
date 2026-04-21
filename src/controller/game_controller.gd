class_name GameController 
extends Node

var station: Station

@onready var satLabel: Label = $UI/DataRow/SatNameLabel
@onready var coordLabel: Label = $UI/DataRow/SatCoordLabel
@onready var dataLabel: Label = $UI/DataRow/DataLabel
@onready var display: DisplayController = $UI/Display
@onready var syncTimer: Timer = $SyncTimer
@onready var syncProgress: ProgressBar = $UI/SyncProgress

func _init() -> void:
	self.station = Station.new()

func _ready() -> void:
	writeData()

	var msgTimer: Timer = Timer.new()
	msgTimer.wait_time = 1.0
	msgTimer.one_shot = true
	msgTimer.autostart = true
	msgTimer.connect("timeout", func(): MessageEvent.emit("System initialization complete"))
	self.add_child(msgTimer)
	msgTimer.start()
	DataEvent.register(self._on_data_received)

func _on_data_received(_int) -> void:
	if self.station.synced:
		self.syncTimer.stop()
		self.station.reset()
		self.syncTimer.start()
		ResetEvent.emit()

func _process(_float) -> void:
	display.update_signals(self.station.satSignal, self.station.satellite.satSignal)
	self.station.update()
	self.syncProgress.value = (syncTimer.time_left / syncTimer.wait_time) * 100
	writeData()

func writeData() -> void:
	self.satLabel.text = "SAT: " + self.station.satellite.name
	self.coordLabel.text = "COORD: " + self.station.satellite.coordinates
	self.dataLabel.text = "DATA: " + str(self.station.data) + "MB"


func _on_sync_timer_timeout() -> void:
	pass # Replace with function body.
