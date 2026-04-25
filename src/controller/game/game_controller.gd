class_name GameController 
extends Node

var station: Station

@export var attackVoice: AudioStream
@export var dataVoice: AudioStream
@export var clearVoice: AudioStream
@export var systemDown: AudioStream
@export var sysDownVoice: AudioStream
@export var systemUp: AudioStream
@export var friendFire: AudioStream

@onready var satLabel: Label = $UI/DataRow/SatNameLabel
@onready var coordLabel: Label = $UI/DataRow/SatCoordLabel
@onready var dataLabel: Label = $UI/DataRow/DataLabel
@onready var display: DisplayController = $UI/Display
@onready var syncTimer: Timer = $SyncTimer
@onready var syncProgress: ProgressBar = $UI/SyncProgress
@onready var gamePlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var wavePlayer: AudioStreamPlayer3D = $WavePlayer
@onready var alarmPlayer: AudioStreamPlayer3D = $AlarmPlayer
@onready var alarmAnim: AnimationPlayer = $AlarmPlayer/AnimationPlayer

var gameStarted: bool = false
var underAttack: bool = false
var _is_reloading: bool = false

func _init() -> void:
	self.station = Station.new()

func _ready() -> void:
	DataEvent.register(self._on_data_received)
	GameOverEvent.register(self._on_game_over)
	GameStartEvent.register(self._on_game_start)
	AttackEvent.register(self._on_attack)

func _on_data_received(_int) -> void:
	if self.station.synced:
		self.syncTimer.stop()
		self.station.reset()
		self.syncTimer.start()
		gamePlayer.stream = dataVoice
		gamePlayer.play()
		ResetEvent.emit()

func _process(_float) -> void:
	if not self.gameStarted:
		return

	display.update_signals(self.station.satSignal, self.station.satellite.satSignal)
	self.station.update()
	self.syncProgress.value = (syncTimer.time_left / syncTimer.wait_time) * 100
	wave_shape_player()
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
	wavePlayer.play()
	writeData()
	gamePlayer.stream = systemUp
	gamePlayer.play()

func _on_sync_timer_timeout() -> void:
	MessageEvent.emit("Satellite reference lost", true)
	DataLossEvent.emit()
	self.station.reset()

func _on_attack(attack: bool) -> void:
	if attack:
		gamePlayer.stream = attackVoice
		gamePlayer.play()
		alarmAnim.play("snooze")
		underAttack = true
	else:
		if underAttack:
			gamePlayer.stream = clearVoice
			gamePlayer.play()
			underAttack = false
		else:
			gamePlayer.stream = friendFire
			gamePlayer.play()
		alarmAnim.stop()

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
	wavePlayer.stop()

	alarmAnim.stop()

	if gamePlayer.playing:
		await gamePlayer.finished

	gamePlayer.stream = systemDown
	gamePlayer.play()
	await gamePlayer.finished

	gamePlayer.stream = sysDownVoice
	gamePlayer.play()
	await gamePlayer.finished

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

func wave_shape_player() -> void:
	var ampDelta = abs(self.station.satSignal.amplitude - self.station.satellite.satSignal.amplitude)
	var freqDelta = abs(self.station.satSignal.frequency - self.station.satellite.satSignal.frequency)
	var delta = sqrt(ampDelta * ampDelta + freqDelta * freqDelta)
	wavePlayer.pitch_scale = delta
	wavePlayer.volume_linear = (1 / delta) + 5
	
func snooze_alarm() -> void:
	alarmPlayer.play()
