class_name Station

const PRECISION: float = 0.5

var data: int
var synced: bool
var shift: int
var attackDetected: bool

var satSignal: SatSignal
var satellite: Satellite
var satFactory: SatFactory
var sigAmpProvider: SigAmpProvider
var sigFreqProvider: SigFreqProvider

func _init() -> void:
	self.sigFreqProvider = SigFreqProvider.new()
	self.sigAmpProvider = SigAmpProvider.new()
	self.satFactory = SatFactory.new()
	self.reset()
	DataEvent.register(self._on_data_received)
	AttackEvent.register(self._on_attack_event)

func reset() -> void:
	self.synced = false
	self.attackDetected = false
	self.shift = 0
	self.satSignal = SatSignal.new(sigFreqProvider.provide(), sigAmpProvider.provide())
	self.satellite = self.satFactory.create_satellite()
	SyncEvent.emit(self.synced)

func setFrequency(frequency: float) -> void:
	self.satSignal.frequency = frequency
	self.satSignal.amplitude = self.sigAmpProvider.provide()

func _on_data_received(d: int) -> void:
	self.data += d

func _on_attack_event(attack: bool) -> void:
	if attack:
		MessageEvent.emit("[YUGEN ALERTHIT]: Alien attack detected", true)
		self.attackDetected = true
	elif self.attackDetected:
		MessageEvent.emit("Alien attack resolved", false)
		self.attackDetected = false
	else:
		MessageEvent.emit("[ERROR]: Friend fire triggered", true)

func update():
	var newSync: bool = abs(self.satSignal.frequency - self.satellite.satSignal.frequency) <= PRECISION and abs(self.satSignal.amplitude - self.satellite.satSignal.amplitude) < PRECISION
	if newSync != self.synced:
		self.synced = newSync
		SyncEvent.emit(newSync)
