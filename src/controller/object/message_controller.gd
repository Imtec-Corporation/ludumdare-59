class_name MessageController
extends VBoxContainer

var scroll: ScrollContainer
var typePlayer: AudioStreamPlayer2D
var errorPlayer: AudioStreamPlayer2D
var messageTimer: Timer
var typeTimer: Timer
var messageQueue: Array[Dictionary] = []
var messageBuffer: Array[Dictionary] = []

func _init() -> void:
	messageTimer = Timer.new()
	messageTimer.wait_time = 0.2
	messageTimer.one_shot = true
	messageTimer.autostart = true
	messageTimer.connect("timeout", self._on_message_timer_timeout)
	self.add_child(messageTimer)

	typeTimer = Timer.new()
	typeTimer.wait_time = 0.01
	typeTimer.one_shot = true
	typeTimer.autostart = true
	typeTimer.connect("timeout", self._on_type_timer_timeout)
	self.add_child(typeTimer)

func _ready() -> void:
	MessageEvent.register(self._on_message_received)
	self.scroll = self.get_parent() as ScrollContainer
	self.typePlayer = $TypePlayer
	self.errorPlayer = $ErrorPlayer

func _on_message_received(message: String, isError: bool) -> void:
	print_debug("Message received: " + message)
	
	if isError:
		errorPlayer.play()

	messageQueue.append({"message": message, "isError": isError})
	if messageTimer.is_stopped():
		messageTimer.start()

func _on_message_timer_timeout() -> void:
	if messageQueue.is_empty():
		return

	var msgDict: Dictionary = messageQueue.pop_front()
	var message: String = msgDict["message"]
	var isError: bool = msgDict["isError"]
	var msgLabel: Label = Label.new()

	var typerMsg: String = "> " + message

	for c in typerMsg:
		messageBuffer.append({"message": c, "isError": isError, "label": msgLabel})

	msgLabel.text = ""
	if isError:
		msgLabel.add_theme_color_override("font_color", Color.RED)
	self.add_child(msgLabel)
	await get_tree().process_frame
	var scrollBar: ScrollBar = self.scroll.get_v_scroll_bar()
	scrollBar.value = scrollBar.max_value

	if typeTimer.is_stopped():
		typeTimer.start()

func _on_type_timer_timeout() -> void:
	if messageBuffer.is_empty():
		return

	var msgDict: Dictionary = messageBuffer.pop_front()
	var message: String = msgDict["message"]
	var isError: bool = msgDict["isError"]
	var label: Label = msgDict["label"]

	if isError:
		label.add_theme_color_override("font_color", Color.RED)

	label.text += message
	typePlayer.play()
	if messageBuffer.is_empty():
		if messageTimer.is_stopped():
			messageTimer.start()
	else:
		typeTimer.start()
