class_name SyncEvent

signal wave_synced(sync: bool)
static var instance: SyncEvent

static func get_instance() -> SyncEvent:
    if instance == null:
        instance = SyncEvent.new()
    return instance

static func register(listener: Callable) -> void:
    get_instance().wave_synced.connect(listener)

static func unregister(listener: Callable) -> void:
    get_instance().wave_synced.disconnect(listener)

static func emit(sync: bool) -> void:
    print_debug("Sync: ", sync)
    get_instance().wave_synced.emit(sync)