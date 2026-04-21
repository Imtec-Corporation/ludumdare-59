class_name ResetEvent

signal reset_requested()

static var instance: ResetEvent

static func get_instance() -> ResetEvent:
	if instance == null:
		instance = ResetEvent.new()
	return instance

static func register(listener: Callable) -> void:
	get_instance().reset_requested.connect(listener)

static func emit() -> void:
	get_instance().reset_requested.emit()