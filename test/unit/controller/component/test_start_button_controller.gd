extends GutTest


func test_hover_and_click_switch_audio_streams() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main: Node3D = main_scene.instantiate()
	add_child_autofree(main)
	await get_tree().process_frame

	var button := main.find_child("StartButton", true, false) as StartButtonController
	assert_not_null(button)
	var hover_stream := AudioStreamWAV.new()
	var click_stream := AudioStreamWAV.new()
	button.hoverSound = hover_stream
	button.clickSound = click_stream

	button.emit_signal("mouse_entered")
	assert_eq(button.clickPlayer.stream, hover_stream)

	button.emit_signal("pressed")
	assert_eq(button.clickPlayer.stream, click_stream)
