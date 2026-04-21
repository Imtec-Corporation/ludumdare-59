class_name MessageController
extends VBoxContainer

func _ready() -> void:
	MessageEvent.register(self._on_message_received)
	var scroll: ScrollContainer = self.get_parent() as ScrollContainer
	scroll.auto_translate = true

func _on_message_received(message: String, isError: bool) -> void:
	print_debug("Message received: " + message)
	var msgLabel: Label = Label.new()
	msgLabel.text = "> " + message
	if isError:
		msgLabel.add_theme_color_override("font_color", Color.RED)
	self.add_child(msgLabel)
