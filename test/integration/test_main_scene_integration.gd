extends GutTest


func test_main_scene_instantiates_with_expected_nodes() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main: Node3D = main_scene.instantiate()
	add_child_autofree(main)
	await get_tree().process_frame

	var game_root := main.find_child("Root", true, false)
	var title_ui := main.find_child("TitleUI", true, false)
	var button := main.find_child("StartButton", true, false)
	var station_cam := main.find_child("Main Cam", true, false)
	var title_cam := main.find_child("Titlecam", true, false)

	assert_not_null(game_root)
	assert_not_null(title_ui)
	assert_not_null(button)
	assert_not_null(station_cam)
	assert_not_null(title_cam)


func test_start_button_starts_game_and_switches_ui_state() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	var main: Node3D = main_scene.instantiate()
	add_child_autofree(main)
	await get_tree().process_frame

	var title_ui := main.find_child("TitleUI", true, false) as Control
	var station_cam := main.find_child("Main Cam", true, false) as Camera3D
	var button := main.find_child("StartButton", true, false) as Button
	var game_root := main.find_child("Root", true, false) as GameController

	assert_not_null(title_ui)
	assert_not_null(station_cam)
	assert_not_null(button)
	assert_not_null(game_root)
	assert_true(title_ui.visible)
	assert_false(station_cam.current)
	assert_false(game_root.gameStarted)

	button.emit_signal("pressed")
	await get_tree().process_frame

	assert_false(title_ui.visible)
	assert_true(station_cam.current)
	assert_true(game_root.gameStarted)
