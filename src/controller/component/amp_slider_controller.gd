class_name AmpSliderController
extends HSlider

var station: Station

func _ready() -> void:
	ResetEvent.register(self._on_reset_requested)
	GameStartEvent.register(self._on_game_start)
	GameOverEvent.register(self._on_game_over)

func _bind_station() -> void:
	var game_root := get_node("../../../..") as Node
	station = game_root.get("station") as Station
	self.value = station.satSignal.amplitude

func _on_value_changed(_float) -> void:
	if station == null:
		return
	station.satSignal.amplitude = value

func _on_reset_requested() -> void:
	self.value = station.satSignal.amplitude

func _on_game_start() -> void:
	call_deferred("_bind_station")

func _on_game_over() -> void:
	GameOverEvent.unregister(self._on_game_over)
	GameStartEvent.unregister(self._on_game_start)
