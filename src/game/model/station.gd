class_name Station

var data: int
var sync: bool
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

func reset() -> void:
    self.data = 0
    self.sync = false
    self.shift = 0
    self.satSignal = SatSignal.new(sigFreqProvider.provide(), sigAmpProvider.provide())
    self.satellite = self.satFactory.create_satellite()

func setFrequency(frequency: float) -> void:
    self.satSignal.frequency = frequency
    self.satSignal.amplitude = self.sigAmpProvider.provide()