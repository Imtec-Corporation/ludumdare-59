extends GutTest

func test_satellite_creation() -> void:
    var nameProvider = StringProviderMock.new()
    var coordinatesProvider = StringProviderMock.new()
    var sigFreqProvider = FloatProviderMock.new()
    var sigAmpProvider = FloatProviderMock.new()
    var satellite = Satellite.new(nameProvider, coordinatesProvider, sigFreqProvider, sigAmpProvider)
    assert_eq(satellite.name, "My mock string")
    assert_eq(satellite.coordinates, "My mock string")
    assert_eq(satellite.satSignal.frequency, 10.0)
    assert_eq(satellite.satSignal.amplitude, 10.0)