extends GutTest


class FixedNameProvider:
	extends SatNameProvider

	var _value: String

	func _init(value: String) -> void:
		_value = value

	func provide() -> Variant:
		return _value


class FixedCoordinatesProvider:
	extends CoordinatesProvider

	var _value: String

	func _init(value: String) -> void:
		_value = value

	func provide() -> Variant:
		return _value


class FixedFreqProvider:
	extends SigFreqProvider

	var _value: float

	func _init(value: float) -> void:
		_value = value

	func provide() -> Variant:
		return _value


class FixedAmpProvider:
	extends SigAmpProvider

	var _value: float

	func _init(value: float) -> void:
		_value = value

	func provide() -> Variant:
		return _value


func test_create_satellite_uses_configured_providers() -> void:
	var factory := SatFactory.new()
	factory.nameProvider = FixedNameProvider.new("SAT-UNIT")
	factory.coordinatesProvider = FixedCoordinatesProvider.new("LYRA-04.2-Y241")
	factory.sigFreqProvider = FixedFreqProvider.new(2.5)
	factory.sigAmpProvider = FixedAmpProvider.new(8.5)

	var sat := factory.create_satellite()

	assert_eq(sat.name, "SAT-UNIT")
	assert_eq(sat.coordinates, "LYRA-04.2-Y241")
	assert_eq(sat.satSignal.frequency, 2.5)
	assert_eq(sat.satSignal.amplitude, 8.5)
