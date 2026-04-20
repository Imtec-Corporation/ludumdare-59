class_name FreqSliderController
extends HSlider

var station: Station

func _ready() -> void:
	# `GameController._ready()` runs after child `_ready()` callbacks, so we bind on the next idle step.
	call_deferred("_bind_station")

func _bind_station() -> void:
	# Root owns `station` (see `GameController` on the scene root in `scenes/main.tscn`).
	var game_root := get_node("../../../..") as Node
	station = game_root.get("station") as Station
	self.value = station.satSignal.frequency

func _on_value_changed(_float) -> void:
	if station == null:
		return
	station.satSignal.frequency = value
