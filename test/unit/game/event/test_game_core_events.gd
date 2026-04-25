extends GutTest

var _attacks: Array[bool] = []
var _reset_count: int = 0
var _game_over_count: int = 0
var _messages: Array[Dictionary] = []


func before_each() -> void:
	_attacks.clear()
	_reset_count = 0
	_game_over_count = 0
	_messages.clear()

	AttackEvent.register(_on_attack)
	ResetEvent.register(_on_reset)
	GameOverEvent.register(_on_game_over)
	MessageEvent.register(_on_message)


func after_each() -> void:
	var attack_listener := Callable(self, "_on_attack")
	if AttackEvent.get_instance().attack_event.is_connected(attack_listener):
		AttackEvent.unregister(attack_listener)

	var reset_listener := Callable(self, "_on_reset")
	if ResetEvent.get_instance().reset_requested.is_connected(reset_listener):
		ResetEvent.get_instance().reset_requested.disconnect(reset_listener)

	var game_over_listener := Callable(self, "_on_game_over")
	if GameOverEvent.get_instance().game_over.is_connected(game_over_listener):
		GameOverEvent.unregister(game_over_listener)

	var msg_listener := Callable(self, "_on_message")
	if MessageEvent.get_instance().message_received.is_connected(msg_listener):
		MessageEvent.get_instance().message_received.disconnect(msg_listener)


func test_attack_event_emits_payload_and_unregister_stops_delivery() -> void:
	AttackEvent.emit(true)
	AttackEvent.unregister(_on_attack)
	AttackEvent.emit(false)

	assert_eq(_attacks, [true])


func test_reset_event_emits_signal() -> void:
	ResetEvent.emit()
	ResetEvent.emit()

	assert_eq(_reset_count, 2)


func test_game_over_event_unregister_is_safe_when_not_connected() -> void:
	GameOverEvent.unregister(_on_game_over)
	GameOverEvent.unregister(_on_game_over)
	GameOverEvent.emit()

	assert_eq(_game_over_count, 0)


func test_message_event_emits_text_and_error_flag() -> void:
	MessageEvent.emit("hello world")
	MessageEvent.emit("boom", true)

	assert_eq(_messages.size(), 2)
	assert_eq(_messages[0]["message"], "hello world")
	assert_false(_messages[0]["is_error"])
	assert_eq(_messages[1]["message"], "boom")
	assert_true(_messages[1]["is_error"])


func _on_attack(attack: bool) -> void:
	_attacks.append(attack)


func _on_reset() -> void:
	_reset_count += 1


func _on_game_over() -> void:
	_game_over_count += 1


func _on_message(message: String, is_error: bool) -> void:
	_messages.append({
		"message": message,
		"is_error": is_error
	})
