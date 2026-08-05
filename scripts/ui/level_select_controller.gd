extends Control


const GAMEPLAY_SCENE_PATH: String = (
	"res://scenes/gameplay/gameplay.tscn"
)

const MAIN_MENU_SCENE_PATH: String = (
	"res://scenes/main_menu/main_menu.tscn"
)

const LEVEL_01: LevelData = preload(
	"res://data/levels/level_01.tres"
)

const LEVEL_02: LevelData = preload(
	"res://data/levels/level_02.tres"
)


@onready var center_container: CenterContainer = (
	$CenterContainer
)

@onready var vbox_container: VBoxContainer = (
	$CenterContainer/VBoxContainer
)

@onready var title_label: Label = (
	$CenterContainer/VBoxContainer/TitleLabel
)

@onready var level_01_button: Button = (
	$CenterContainer/VBoxContainer/Level01Button
)

@onready var level_02_button: Button = (
	$CenterContainer/VBoxContainer/Level02Button
)

@onready var back_to_main_menu_button: Button = (
	$CenterContainer/VBoxContainer/BackToMainMenuButton
)


func _ready() -> void:
	_configure_interface()
	_connect_buttons()

	if not get_viewport().size_changed.is_connected(
		_apply_layout
	):
		get_viewport().size_changed.connect(
			_apply_layout
		)

	call_deferred("_apply_layout")

	print("LEVEL SELECT READY")

	print(
		"Level 01 signal connected: ",
		level_01_button.pressed.is_connected(
			_on_level_01_pressed
		)
	)

	print(
		"Level 02 signal connected: ",
		level_02_button.pressed.is_connected(
			_on_level_02_pressed
		)
	)

	print(
		"Back to main signal connected: ",
		back_to_main_menu_button.pressed.is_connected(
			_on_back_to_main_menu_pressed
		)
	)


func _configure_interface() -> void:
	visible = true
	center_container.visible = true
	vbox_container.visible = true
	title_label.visible = true
	level_01_button.visible = true
	level_02_button.visible = true
	back_to_main_menu_button.visible = true

	custom_maximum_size = Vector2(-1.0, -1.0)
	center_container.custom_maximum_size = Vector2(-1.0, -1.0)
	vbox_container.custom_maximum_size = Vector2(-1.0, -1.0)
	title_label.custom_maximum_size = Vector2(-1.0, -1.0)
	level_01_button.custom_maximum_size = Vector2(-1.0, -1.0)
	level_02_button.custom_maximum_size = Vector2(-1.0, -1.0)
	back_to_main_menu_button.custom_maximum_size = Vector2(-1.0, -1.0)

	title_label.text = "SELECT LEVEL"
	level_01_button.text = "LEVEL 01"
	level_02_button.text = "LEVEL 02"
	back_to_main_menu_button.text = "BACK TO MAIN MENU"

	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center_container.mouse_filter = Control.MOUSE_FILTER_PASS
	vbox_container.mouse_filter = Control.MOUSE_FILTER_PASS

	level_01_button.mouse_filter = Control.MOUSE_FILTER_STOP
	level_02_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_to_main_menu_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	level_01_button.disabled = false
	level_02_button.disabled = false
	back_to_main_menu_button.disabled = false

	level_01_button.focus_mode = Control.FOCUS_ALL
	level_02_button.focus_mode = Control.FOCUS_ALL
	back_to_main_menu_button.focus_mode = Control.FOCUS_ALL

	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	title_label.custom_minimum_size = Vector2(
		340.0,
		52.0
	)

	title_label.add_theme_font_size_override(
		"font_size",
		28
	)

	level_01_button.custom_minimum_size = Vector2(
		340.0,
		58.0
	)

	level_02_button.custom_minimum_size = Vector2(
		340.0,
		58.0
	)

	back_to_main_menu_button.custom_minimum_size = Vector2(
		340.0,
		58.0
	)

	level_01_button.add_theme_font_size_override(
		"font_size",
		22
	)

	level_02_button.add_theme_font_size_override(
		"font_size",
		22
	)

	back_to_main_menu_button.add_theme_font_size_override(
		"font_size",
		20
	)

	vbox_container.custom_minimum_size = Vector2(
		340.0,
		285.0
	)

	vbox_container.add_theme_constant_override(
		"separation",
		14
	)


func _connect_buttons() -> void:
	if not level_01_button.pressed.is_connected(
		_on_level_01_pressed
	):
		level_01_button.pressed.connect(
			_on_level_01_pressed
		)

	if not level_02_button.pressed.is_connected(
		_on_level_02_pressed
	):
		level_02_button.pressed.connect(
			_on_level_02_pressed
		)

	if not back_to_main_menu_button.pressed.is_connected(
		_on_back_to_main_menu_pressed
	):
		back_to_main_menu_button.pressed.connect(
			_on_back_to_main_menu_pressed
		)


func _apply_layout() -> void:
	var viewport_size: Vector2 = (
		get_viewport_rect().size
	)

	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0

	offset_left = 0.0
	offset_top = 0.0
	offset_right = viewport_size.x
	offset_bottom = viewport_size.y

	center_container.anchor_left = 0.0
	center_container.anchor_top = 0.0
	center_container.anchor_right = 0.0
	center_container.anchor_bottom = 0.0

	center_container.offset_left = 0.0
	center_container.offset_top = 0.0
	center_container.offset_right = viewport_size.x
	center_container.offset_bottom = viewport_size.y

	center_container.queue_sort()
	vbox_container.queue_sort()

	print(
		"Level select arranged: ",
		viewport_size
	)


func _on_level_01_pressed() -> void:
	print("LEVEL 01 BUTTON PRESSED")
	_start_level(LEVEL_01)


func _on_level_02_pressed() -> void:
	print("LEVEL 02 BUTTON PRESSED")
	_start_level(LEVEL_02)


func _start_level(
	level: LevelData
) -> void:
	if level == null:
		push_error(
			"LevelSelect: selected level is null."
		)
		return

	print(
		"Starting level: ",
		level.id
	)

	GameSession.select_level(level)

	print(
		"Opening scene: ",
		GAMEPLAY_SCENE_PATH
	)

	var error: Error = (
		get_tree().change_scene_to_file(
			GAMEPLAY_SCENE_PATH
		)
	)

	if error != OK:
		push_error(
			"LevelSelect: failed to open gameplay scene. Error: "
			+ str(error)
		)


func _on_back_to_main_menu_pressed() -> void:
	print("BACK TO MAIN MENU BUTTON PRESSED")

	GameSession.clear_selected_level()

	var error: Error = (
		get_tree().change_scene_to_file(
			MAIN_MENU_SCENE_PATH
		)
	)

	if error != OK:
		push_error(
			"LevelSelect: failed to open main menu. Error: "
			+ str(error)
		)
