class_name AlienController
extends Node

var prepareTimer: Timer
var attackTimer: Timer

const ATTACK_TIME: float = 10.0

func _ready() -> void:
	self.prepareTimer = Timer.new()
	self.prepareTimer.one_shot = true
	self.prepareTimer.connect("timeout", self.on_prepare_timer_timeout)
	self.add_child(self.prepareTimer)

	self.attackTimer = Timer.new()
	self.attackTimer.wait_time = 10.0
	self.attackTimer.one_shot = true
	self.attackTimer.connect("timeout", self.on_attack_timer_timeout)
	self.add_child(self.attackTimer)

	AttackEvent.register(self._on_attack_event)
	self.start_timer()

func start_timer() -> void:
	self.prepareTimer.wait_time = randf_range(10.0, 50.0)
	self.prepareTimer.start()

func on_prepare_timer_timeout() -> void:
	self.attackTimer.start()
	AttackEvent.emit(true)

func on_attack_timer_timeout() -> void:
	MessageEvent.emit("Alien attack completed, all links lost!", true)

func _on_attack_event(attack: bool) -> void:
	if not attack and not attackTimer.is_stopped():
		attackTimer.stop()
		start_timer()
