class_name AmpSliderController
extends HSlider

var station: Station

func _ready() -> void:
	call_deferred("_bind_station")
	ResetEvent.register(self._on_reset_requested)

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
