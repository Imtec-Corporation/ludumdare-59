extends GutTest


class FixedProvider:
	extends IRandProvider

	var _value: Variant

	func _init(value: Variant) -> void:
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


class SatFactoryMock:
	extends SatFactory

	var _satellite: Satellite

	func _init(satellite: Satellite) -> void:
		_satellite = satellite

	func create_satellite() -> Satellite:
		return _satellite


var _sync_events: Array[bool] = []
var _messages: Array[Dictionary] = []
var _game_over_emitted: bool = false


func before_each() -> void:
	_sync_events.clear()
	_messages.clear()
	_game_over_emitted = false


func after_each() -> void:
	var sync_listener := Callable(self, "_on_sync")
	if SyncEvent.get_instance().wave_synced.is_connected(sync_listener):
		SyncEvent.unregister(sync_listener)

	var msg_listener := Callable(self, "_on_message")
	if MessageEvent.get_instance().message_received.is_connected(msg_listener):
		MessageEvent.get_instance().message_received.disconnect(msg_listener)

	var game_over_listener := Callable(self, "_on_game_over")
	if GameOverEvent.get_instance().game_over.is_connected(game_over_listener):
		GameOverEvent.unregister(game_over_listener)


func test_reset_initializes_signal_and_satellite() -> void:
	var station := Station.new()
	station.sigFreqProvider = FixedFreqProvider.new(3.5)
	station.sigAmpProvider = FixedAmpProvider.new(7.0)
	var satellite := Satellite.new(
		FixedProvider.new("SAT-TEST"),
		FixedProvider.new("ORION-01.1-X100"),
		FixedProvider.new(2.0),
		FixedProvider.new(1.0)
	)
	station.satFactory = SatFactoryMock.new(satellite)
	SyncEvent.register(_on_sync)
	MessageEvent.register(_on_message)

	station.reset()

	assert_true(station.initialized)
	assert_eq(station.satSignal.frequency, 3.5)
	assert_eq(station.satSignal.amplitude, 7.0)
	assert_eq(station.satellite.name, "SAT-TEST")
	assert_eq(station.satellite.coordinates, "ORION-01.1-X100")
	assert_eq(_sync_events, [false])
	assert_eq(_messages.size(), 1)
	assert_string_contains(_messages[0]["message"], "Satellite reference set: SAT-TEST")
	assert_false(_messages[0]["is_error"])


func test_update_only_emits_on_sync_state_changes() -> void:
	var station := Station.new()
	station.satSignal = SatSignal.new(5.0, 5.0)
	station.satellite = Satellite.new(
		FixedProvider.new("SAT-A"),
		FixedProvider.new("ORION-02.1-X111"),
		FixedProvider.new(5.0),
		FixedProvider.new(5.0)
	)
	station.synced = false
	SyncEvent.register(_on_sync)

	station.update()
	station.update()
	station.satellite.satSignal.frequency = 8.0
	station.update()

	assert_false(station.synced)
	assert_eq(_sync_events, [true, false])


func test_data_loss_is_capped_and_triggers_game_over() -> void:
	var station := Station.new()
	station.data = 10
	MessageEvent.register(_on_message)
	GameOverEvent.register(_on_game_over)

	station._on_data_lost(99)

	assert_eq(station.data, 0)
	assert_true(_game_over_emitted)
	assert_eq(_messages.size(), 1)
	assert_string_contains(_messages[0]["message"], "Data loss: 10MB")
	assert_true(_messages[0]["is_error"])


func _on_sync(sync: bool) -> void:
	_sync_events.append(sync)


func _on_message(message: String, is_error: bool) -> void:
	_messages.append({
		"message": message,
		"is_error": is_error
	})


func _on_game_over() -> void:
	_game_over_emitted = true
