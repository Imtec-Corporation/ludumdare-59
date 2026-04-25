class_name  GameStartEvent

signal start_game

static var instance: GameStartEvent

static func get_instance() -> GameStartEvent:
	if instance == null:
		instance = GameStartEvent.new()
	return instance

static func register(callback: Callable) -> void:
	get_instance().start_game.connect(callback)

static func unregister(callback: Callable) -> void:
	get_instance().start_game.disconnect(callback)

static func emit() -> void:
	get_instance().start_game.emit()