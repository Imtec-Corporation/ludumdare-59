extends GutTest

var _messages: Array[Dictionary] = []
var _data_received: Array[int] = []
var _data_lost: Array[int] = []
var _sync_states: Array[bool] = []
var _start_count: int = 0


func before_each() -> void:
	_messages.clear()
	_data_received.clear()
	_data_lost.clear()
	_sync_states.clear()
	_start_count = 0

	MessageEvent.register(_on_message)
	DataEvent.register(_on_data_received)
	DataLossEvent.register(_on_data_lost)
	SyncEvent.register(_on_sync_changed)
	GameStartEvent.register(_on_game_start)


func after_each() -> void:
	var message_listener := Callable(self, "_on_message")
	if MessageEvent.get_instance().message_received.is_connected(message_listener):
		MessageEvent.get_instance().message_received.disconnect(message_listener)

	var data_listener := Callable(self, "_on_data_received")
	if DataEvent.get_instance().data_received.is_connected(data_listener):
		DataEvent.unregister(data_listener)

	var data_loss_listener := Callable(self, "_on_data_lost")
	if DataLossEvent.get_instance().data_loss_event.is_connected(data_loss_listener):
		DataLossEvent.unregister(data_loss_listener)

	var sync_listener := Callable(self, "_on_sync_changed")
	if SyncEvent.get_instance().wave_synced.is_connected(sync_listener):
		SyncEvent.unregister(sync_listener)

	var game_start_listener := Callable(self, "_on_game_start")
	if GameStartEvent.get_instance().start_game.is_connected(game_start_listener):
		GameStartEvent.unregister(game_start_listener)


func test_data_event_emits_data_and_message() -> void:
	DataEvent.emit()

	assert_eq(_data_received.size(), 1)
	assert_true(_data_received[0] >= 50 and _data_received[0] <= 1000)
	assert_eq(_messages.size(), 1)
	assert_string_contains(_messages[0]["message"], "Data transmitted:")
	assert_false(_messages[0]["is_error"])


func test_data_loss_event_emits_loss_value() -> void:
	DataLossEvent.emit()

	assert_eq(_data_lost.size(), 1)
	assert_true(_data_lost[0] >= 50 and _data_lost[0] <= 1000)


func test_sync_event_emits_state_and_optional_messages() -> void:
	SyncEvent.emit(true, true)
	SyncEvent.emit(false, true)
	SyncEvent.emit(false, false)

	assert_eq(_sync_states, [true, false, false])
	assert_eq(_messages.size(), 2)
	assert_eq(_messages[0]["message"], "Synchronization complete")
	assert_eq(_messages[1]["message"], "Synchronization lost")
	assert_true(_messages[1]["is_error"])


func test_game_start_event_broadcasts() -> void:
	GameStartEvent.emit()
	GameStartEvent.emit()

	assert_eq(_start_count, 2)


func _on_message(message: String, is_error: bool) -> void:
	_messages.append({
		"message": message,
		"is_error": is_error
	})


func _on_data_received(data: int) -> void:
	_data_received.append(data)


func _on_data_lost(loss: int) -> void:
	_data_lost.append(loss)


func _on_sync_changed(sync: bool) -> void:
	_sync_states.append(sync)


func _on_game_start() -> void:
	_start_count += 1
