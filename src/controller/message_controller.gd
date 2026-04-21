class_name MessageController
extends VBoxContainer

var scroll: ScrollContainer

func _ready() -> void:
	MessageEvent.register(self._on_message_received)
	self.scroll = self.get_parent() as ScrollContainer

func _on_message_received(message: String, isError: bool) -> void:
	print_debug("Message received: " + message)
	var msgLabel: Label = Label.new()
	msgLabel.text = "> " + message
	if isError:
		msgLabel.add_theme_color_override("font_color", Color.RED)
	self.add_child(msgLabel)
	await get_tree().process_frame
	var scrollBar: ScrollBar = self.scroll.get_v_scroll_bar()
	scrollBar.value = scrollBar.max_value
