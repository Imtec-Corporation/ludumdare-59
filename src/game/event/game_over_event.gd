class_name GameOverEvent

signal game_over()

static var instance: GameOverEvent

static func get_instance() -> GameOverEvent:
	if instance == null:
		instance = GameOverEvent.new()
	return instance

static func register(f: Callable) -> void:
	get_instance().game_over.connect(f)

static func unregister(f: Callable) -> void:
	if get_instance().game_over.is_connected(f):
		get_instance().game_over.disconnect(f)

static func emit() -> void:
	get_instance().game_over.emit()