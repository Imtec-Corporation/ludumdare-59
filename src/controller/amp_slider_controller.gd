class_name AmpSliderController
extends HSlider

var station: Station

func _ready() -> void:
	call_deferred("_bind_station")

func _bind_station() -> void:
	var game_root := get_node("../../../..") as Node
	station = game_root.get("station") as Station
	self.value = station.satSignal.amplitude

func _on_value_changed(_float) -> void:
	if station == null:
		return
	station.satSignal.amplitude = value
