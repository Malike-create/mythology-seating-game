extends Control


const LEVEL_SELECT_SCENE_PATH: String = (
	"res://scenes/level_select/level_select.tscn"
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

@onready var play_button: Button = (
	$CenterContainer/VBoxContainer/PlayButton
)

@onready var album_button: Button = (
	$CenterContainer/VBoxContainer/AlbumButton
)

@onready var exit_button: Button = (
	$CenterContainer/VBoxContainer/ExitButton
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

	print("MAIN MENU READY")
	print(
		"Play signal connected: ",
		play_button.pressed.is_connected(
			_on_play_pressed
		)
	)
	print(
		"Exit signal connected: ",
		exit_button.pressed.is_connected(
			_on_exit_pressed
		)
	)


func _configure_interface() -> void:
	## Показываем все элементы.
	visible = true
	center_container.visible = true
	vbox_container.visible = true
	title_label.visible = true
	play_button.visible = true
	album_button.visible = true
	exit_button.visible = true

	## Убираем ограничение максимального размера.
	custom_maximum_size = Vector2(-1.0, -1.0)
	center_container.custom_maximum_size = Vector2(-1.0, -1.0)
	vbox_container.custom_maximum_size = Vector2(-1.0, -1.0)
	title_label.custom_maximum_size = Vector2(-1.0, -1.0)
	play_button.custom_maximum_size = Vector2(-1.0, -1.0)
	album_button.custom_maximum_size = Vector2(-1.0, -1.0)
	exit_button.custom_maximum_size = Vector2(-1.0, -1.0)

	## Тексты.
	title_label.text = "MYTHOLOGY SEATING GAME"
	play_button.text = "PLAY"
	album_button.text = "ALBUM — COMING SOON"
	exit_button.text = "EXIT"

	## Заголовок не перехватывает мышь.
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
	play_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	album_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	exit_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	## PLAY и EXIT доступны.
	play_button.disabled = false
	exit_button.disabled = false

	## ALBUM пока временно отключён.
	album_button.disabled = true
	album_button.tooltip_text = (
		"Album will be added later."
	)

	## Управление клавиатурой.
	play_button.focus_mode = Control.FOCUS_ALL
	exit_button.focus_mode = Control.FOCUS_ALL

	## Заголовок.
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	title_label.custom_minimum_size = Vector2(
		440.0,
		70.0
	)

	title_label.add_theme_font_size_override(
		"font_size",
		32
	)

	## Размеры кнопок.
	play_button.custom_minimum_size = Vector2(
		380.0,
		58.0
	)

	album_button.custom_minimum_size = Vector2(
		380.0,
		58.0
	)

	exit_button.custom_minimum_size = Vector2(
		380.0,
		58.0
	)

	play_button.add_theme_font_size_override(
		"font_size",
		22
	)

	album_button.add_theme_font_size_override(
		"font_size",
		22
	)

	exit_button.add_theme_font_size_override(
		"font_size",
		22
	)

	vbox_container.custom_minimum_size = Vector2(
		440.0,
		300.0
	)

	vbox_container.add_theme_constant_override(
		"separation",
		14
	)


func _connect_buttons() -> void:
	if not play_button.pressed.is_connected(
		_on_play_pressed
	):
		play_button.pressed.connect(
			_on_play_pressed
		)

	if not exit_button.pressed.is_connected(
		_on_exit_pressed
	):
		exit_button.pressed.connect(
			_on_exit_pressed
		)


func _apply_layout() -> void:
	var viewport_size: Vector2 = (
		get_viewport_rect().size
	)

	## Корневой MainMenu занимает всё окно.
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
		"Main menu arranged: ",
		viewport_size
	)


func _on_play_pressed() -> void:
	print("PLAY BUTTON PRESSED")

	GameSession.clear_selected_level()

	var error: Error = get_tree().change_scene_to_file(
		LEVEL_SELECT_SCENE_PATH
	)

	if error != OK:
		push_error(
			"MainMenu: failed to open level select. Error: "
			+ str(error)
		)


func _on_exit_pressed() -> void:
	print("EXIT BUTTON PRESSED")
	get_tree().quit()
	
