extends GutTest


func test_sat_signal_stores_frequency_and_amplitude() -> void:
	var sat_signal := SatSignal.new(6.25, 3.75)

	assert_eq(sat_signal.frequency, 6.25)
	assert_eq(sat_signal.amplitude, 3.75)
