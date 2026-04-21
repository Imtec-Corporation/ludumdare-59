class_name Station

const PRECISION: float = 0.5

var data: int
var synced: bool
var shift: int
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

func reset() -> void:
	self.synced = false
	self.shift = 0
	self.satSignal = SatSignal.new(sigFreqProvider.provide(), sigAmpProvider.provide())
	self.satellite = self.satFactory.create_satellite()
	SyncEvent.emit(self.synced)

func setFrequency(frequency: float) -> void:
	self.satSignal.frequency = frequency
	self.satSignal.amplitude = self.sigAmpProvider.provide()

func _on_data_received(d: int) -> void:
	self.data += d

func update():
	var newSync: bool = abs(self.satSignal.frequency - self.satellite.satSignal.frequency) <= PRECISION and abs(self.satSignal.amplitude - self.satellite.satSignal.amplitude) < PRECISION
	if newSync != self.synced:
		self.synced = newSync
		SyncEvent.emit(newSync)
