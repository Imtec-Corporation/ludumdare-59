class_name DataEvent

signal data_received(data: int)

static var instance: DataEvent

static func get_instance() -> DataEvent:
	if instance == null:
		instance = DataEvent.new()
	return instance

static func register(listener: Callable) -> void:
	get_instance().data_received.connect(listener)

static func emit() -> void:
	var data: int = DataProvider.new().provide()
	get_instance().data_received.emit(data)
	MessageEvent.emit("Stable data link established: " + str(data) + "MB")
