extends Control


const GAMEPLAY_SCENE_PATH: String = (
	"res://scenes/gameplay/gameplay.tscn"
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
	print("Level 01 signal connected: ",
		level_01_button.pressed.is_connected(
			_on_level_01_pressed
		)
	)
	print("Level 02 signal connected: ",
		level_02_button.pressed.is_connected(
			_on_level_02_pressed
		)
	)


func _configure_interface() -> void:
	## Показываем все узлы.
	visible = true
	center_container.visible = true
	vbox_container.visible = true
	title_label.visible = true
	level_01_button.visible = true
	level_02_button.visible = true

	## Убираем ограничение максимального размера.
	custom_maximum_size = Vector2(-1.0, -1.0)
	center_container.custom_maximum_size = Vector2(-1.0, -1.0)
	vbox_container.custom_maximum_size = Vector2(-1.0, -1.0)
	title_label.custom_maximum_size = Vector2(-1.0, -1.0)
	level_01_button.custom_maximum_size = Vector2(-1.0, -1.0)
	level_02_button.custom_maximum_size = Vector2(-1.0, -1.0)

	## Устанавливаем тексты.
	title_label.text = "SELECT LEVEL"
	level_01_button.text = "LEVEL 01"
	level_02_button.text = "LEVEL 02"

	## Заголовок не должен перехватывать мышь.
	title_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	## Контейнеры пропускают события к кнопкам.
	center_container.mouse_filter = (
		Control.MOUSE_FILTER_PASS
	)

	vbox_container.mouse_filter = (
		Control.MOUSE_FILTER_PASS
	)

	## Кнопки принимают события мыши.
	level_01_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	level_02_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	## Убеждаемся, что кнопки активны.
	level_01_button.disabled = false
	level_02_button.disabled = false

	## Разрешаем управление с клавиатуры.
	level_01_button.focus_mode = (
		Control.FOCUS_ALL
	)

	level_02_button.focus_mode = (
		Control.FOCUS_ALL
	)

	## Заголовок.
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

	## Первая кнопка.
	level_01_button.custom_minimum_size = Vector2(
		340.0,
		58.0
	)

	level_01_button.add_theme_font_size_override(
		"font_size",
		22
	)

	## Вторая кнопка.
	level_02_button.custom_minimum_size = Vector2(
		340.0,
		58.0
	)

	level_02_button.add_theme_font_size_override(
		"font_size",
		22
	)

	## Расстояние между элементами.
	vbox_container.custom_minimum_size = Vector2(
		340.0,
		210.0
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


func _apply_layout() -> void:
	var viewport_size: Vector2 = (
		get_viewport_rect().size
	)

	## Размер корневого LevelSelect.
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0

	offset_left = 0.0
	offset_top = 0.0
	offset_right = viewport_size.x
	offset_bottom = viewport_size.y

	## CenterContainer занимает всё окно.
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


func _start_level(level: LevelData) -> void:
	if level == null:
		push_error(
			"LevelSelect: selected level is null."
		)
		return

	print("Starting level: ", level.id)

	GameSession.select_level(level)

	print(
		"Opening scene: ",
		GAMEPLAY_SCENE_PATH
	)

	var error: Error = get_tree().change_scene_to_file(
		GAMEPLAY_SCENE_PATH
	)

	if error != OK:
		push_error(
			"LevelSelect: failed to open gameplay scene. Error: "
			+ str(error)
		)
