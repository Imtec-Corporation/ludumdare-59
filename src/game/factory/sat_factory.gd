class_name SatFactory

var nameProvider: SatNameProvider
var coordinatesProvider: CoordinatesProvider
var sigFreqProvider: SigFreqProvider
var sigAmpProvider: SigAmpProvider

func _init() -> void:
    self.nameProvider = SatNameProvider.new()
    self.coordinatesProvider = CoordinatesProvider.new()
    self.sigFreqProvider = SigFreqProvider.new()
    self.sigAmpProvider = SigAmpProvider.new()

func create_satellite() -> Satellite:
    return Satellite.new(
        nameProvider,
        coordinatesProvider,
        sigFreqProvider,
        sigAmpProvider
    )