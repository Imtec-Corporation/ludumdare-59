class_name DataLossEvent

signal data_loss_event(loss: int)

static var instance: DataLossEvent

static func get_instance() -> DataLossEvent:
	if instance == null:
		instance = DataLossEvent.new()
	return instance

static func register(listener: Callable) -> void:
	get_instance().data_loss_event.connect(listener)

static func unregister(listener: Callable) -> void:
	get_instance().data_loss_event.disconnect(listener)

static func emit() -> void:
	var loss: int = randi_range(10, 500)
	get_instance().data_loss_event.emit(loss)