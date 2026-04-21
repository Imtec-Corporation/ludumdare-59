class_name MessageEvent

signal message_received(message: String, isError: bool)

static var instance: MessageEvent

static func get_instance() -> MessageEvent:
    if instance == null:
        instance = MessageEvent.new()
    return instance

static func register(listener: Callable) -> void:
    get_instance().message_received.connect(listener)

static func emit(message: String, isError: bool = false) -> void:
    print_debug("Sending message: " + message)
    get_instance().message_received.emit(message, isError)