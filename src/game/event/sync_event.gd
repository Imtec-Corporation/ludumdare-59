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

static func emit(sync: bool, verbose: bool = true) -> void:
    print_debug("Sync: ", sync)
    get_instance().wave_synced.emit(sync)
    if verbose:
        if sync:
            MessageEvent.emit("Synchronization complete")
        else:
            MessageEvent.emit("Synchronization lost", true)