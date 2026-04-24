class_name AttackEvent

signal attack_event(attack: bool)

static var instance: AttackEvent

static func get_instance() -> AttackEvent:
	if instance == null:
		instance = AttackEvent.new()
	return instance

static func register(listener: Callable) -> void:
	get_instance().attack_event.connect(listener)

static func unregister(listener: Callable) -> void:
	get_instance().attack_event.disconnect(listener)

static func emit(attack: bool) -> void:
	get_instance().attack_event.emit(attack)