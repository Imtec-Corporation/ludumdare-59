class_name Satellite

var name: String
var coordinates: String
var satSignal: SatSignal

func _init(nameProvider: IRandProvider,
	coordinatesProvider: IRandProvider,
	sigFreqProvider: IRandProvider,
	sigAmpProvider: IRandProvider) -> void:
	self.name = nameProvider.provide()
	self.coordinates = coordinatesProvider.provide()
	self.satSignal = SatSignal.new(sigFreqProvider.provide(), sigAmpProvider.provide())
