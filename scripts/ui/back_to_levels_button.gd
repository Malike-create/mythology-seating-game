extends Button


const LEVEL_SELECT_SCENE_PATH: String = (
	"res://scenes/level_select/level_select.tscn"
)


func _ready() -> void:
	_configure_button()
	_connect_button()

	if not get_viewport().size_changed.is_connected(
		_update_button_position
	):
		get_viewport().size_changed.connect(
			_update_button_position
		)

	call_deferred("_update_button_position")

	print("BACK TO LEVELS BUTTON READY")


func _configure_button() -> void:
	text = "BACK TO LEVELS"

	visible = true
	disabled = false

	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL

	custom_minimum_size = Vector2(
		190.0,
		46.0
	)

	custom_maximum_size = Vector2(
		-1.0,
		-1.0
	)

	add_theme_font_size_override(
		"font_size",
		18
	)

	## Показываем кнопку поверх основного интерфейса.
	z_index = 100


func _connect_button() -> void:
	if not pressed.is_connected(
		_on_back_to_levels_pressed
	):
		pressed.connect(
			_on_back_to_levels_pressed
		)

	print(
		"Back button signal connected: ",
		pressed.is_connected(
			_on_back_to_levels_pressed
		)
	)


func _update_button_position() -> void:
	var viewport_size: Vector2 = (
		get_viewport_rect().size
	)

	var button_left: float = maxf(
		20.0,
		viewport_size.x - 210.0
	)

	## Используем обычные якоря,
	## чтобы позиция не перезаписывалась.
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0

	## Кнопка находится в правом верхнем углу.
	offset_left = button_left
	offset_top = 20.0
	offset_right = button_left + 190.0
	offset_bottom = 66.0

	print(
		"Back button position updated: ",
		position
	)


func _on_back_to_levels_pressed() -> void:
	print("BACK TO LEVELS BUTTON PRESSED")

	GameSession.clear_selected_level()

	var error: Error = get_tree().change_scene_to_file(
		LEVEL_SELECT_SCENE_PATH
	)

	if error != OK:
		push_error(
			"BackToLevelsButton: failed to open level select. Error: "
			+ str(error)
		)
