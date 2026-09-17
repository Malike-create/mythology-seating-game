class_name SeatSlot
extends PanelContainer


signal creature_dropped(
	drag_data: Dictionary,
	seat_index: int
)


@export var seat_index: int = 0


## Существо, которое сейчас сидит здесь.
var creature_data: CreatureData


@onready var portrait_rect: TextureRect = (
	$CenterContainer/VBoxContainer/PortraitRect
)

@onready var name_label: Label = (
	$CenterContainer/VBoxContainer/NameLabel
)

@onready var happiness_label: Label = (
	$CenterContainer/VBoxContainer/HappinessLabel
)

@onready var status_label: Label = (
	$CenterContainer/VBoxContainer/StatusLabel
)


func _ready() -> void:
	custom_minimum_size = Vector2(180, 180)

	_refresh_visual()


func _get_drag_data(
	_at_position: Vector2
) -> Variant:
	if creature_data == null:
		return null

	var drag_data: Dictionary = {
		"creature_data": creature_data,
		"source_seat_index": seat_index,
		"source_card": null
	}

	set_drag_preview(
		_create_drag_preview()
	)

	return drag_data


func _create_drag_preview() -> Control:
	var preview := PanelContainer.new()

	preview.custom_minimum_size = Vector2(
		160,
		140
	)

	var preview_vbox := VBoxContainer.new()

	preview.add_child(
		preview_vbox
	)

	var preview_portrait := TextureRect.new()

	preview_portrait.custom_minimum_size = Vector2(
		140,
		90
	)

	preview_portrait.expand_mode = (
		TextureRect.EXPAND_IGNORE_SIZE
	)

	preview_portrait.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	)

	if creature_data.portrait != null:
		preview_portrait.texture = (
			creature_data.portrait
		)

	preview_vbox.add_child(
		preview_portrait
	)

	var preview_label := Label.new()

	preview_label.text = _get_display_name()

	preview_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	preview_vbox.add_child(
		preview_label
	)

	return preview


func _can_drop_data(
	_at_position: Vector2,
	data: Variant
) -> bool:
	if not data is Dictionary:
		return false

	if not data.has("creature_data"):
		return false

	return data["creature_data"] is CreatureData


func _drop_data(
	_at_position: Vector2,
	data: Variant
) -> void:
	if not _can_drop_data(
		_at_position,
		data
	):
		return

	creature_dropped.emit(
		data,
		seat_index
	)


func set_creature(
	new_creature: CreatureData
) -> void:
	creature_data = new_creature

	_refresh_visual()


func clear_slot() -> void:
	creature_data = null

	_refresh_visual()


func is_occupied() -> bool:
	return creature_data != null


## GameplayController будет вызывать этот метод
## после каждого пересчёта счастья.
func set_happiness_result(
	result: CreatureHappinessResult
) -> void:
	if creature_data == null:
		_clear_happiness_visual()
		return

	if result == null:
		_clear_happiness_visual()
		return

	happiness_label.text = (
		"Happiness: "
		+ str(result.total_score)
	)

	status_label.text = _get_status_text(
		result
	)


func _get_status_text(
	result: CreatureHappinessResult
) -> String:
	if result.has_critical_neighbor:
		return "CRITICAL!"

	if result.total_score >= 3:
		return "HAPPY"

	if result.total_score > 0:
		return "CONTENT"

	if result.total_score == 0:
		return "NEUTRAL"

	return "UNHAPPY"


func _clear_happiness_visual() -> void:
	happiness_label.text = "Happiness: —"

	if creature_data == null:
		status_label.text = "EMPTY"
	else:
		status_label.text = "WAITING"


func _refresh_visual() -> void:
	if portrait_rect == null:
		return

	if name_label == null:
		return

	if happiness_label == null:
		return

	if status_label == null:
		return

	if creature_data == null:
		portrait_rect.texture = null
		name_label.text = "EMPTY"

		_clear_happiness_visual()
		return

	portrait_rect.texture = creature_data.portrait
	name_label.text = _get_display_name()

	_clear_happiness_visual()


func _get_display_name() -> String:
	if creature_data == null:
		return "EMPTY"

	var key: String = String(
		creature_data.name_key
	)

	if key.is_empty():
		return String(
			creature_data.id
		)

	var translated_name: String = tr(
		key
	)

	if translated_name == key:
		return String(
			creature_data.id
		)

	return translated_name
