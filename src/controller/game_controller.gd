class_name GameController 
extends Node

var station: Station

@onready var satLabel: Label = $UI/DataRow/SatNameLabel
@onready var coordLabel: Label = $UI/DataRow/SatCoordLabel
@onready var dataLabel: Label = $UI/DataRow/DataLabel
@onready var display: DisplayController = $UI/Display

func _ready() -> void:
	self.station = Station.new()
	writeData()
	
func _process(_float) -> void:
	display.update_signals(self.station.satSignal, self.station.satellite.satSignal)
	writeData()

func writeData() -> void:
	self.satLabel.text = "SAT: " + self.station.satellite.name
	self.coordLabel.text = "COORD: " + self.station.satellite.coordinates
	self.dataLabel.text = "DATA: " + str(self.station.data) + "TB"
