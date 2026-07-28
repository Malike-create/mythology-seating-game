class_name CreatureCard
extends PanelContainer


## Данные существа этой карточки.
@export var creature_data: CreatureData


@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var category_label: Label = $VBoxContainer/CategoryLabel


func _ready() -> void:
	custom_minimum_size = Vector2(180, 120)

	_refresh_visual()


func set_creature(
	new_creature_data: CreatureData
) -> void:
	creature_data = new_creature_data

	_refresh_visual()


## Начало перетаскивания карточки из руки.
func _get_drag_data(
	_at_position: Vector2
) -> Variant:
	if creature_data == null:
		return null

	var drag_data: Dictionary = {
		"creature_data": creature_data,

		## -1 означает:
		## существо пришло не с места за столом,
		## а из руки.
		"source_seat_index": -1,

		## Сохраняем ссылку на карточку.
		"source_card": self
	}

	set_drag_preview(
		_create_drag_preview()
	)

	return drag_data


func _create_drag_preview() -> Control:
	var preview := PanelContainer.new()

	preview.custom_minimum_size = Vector2(
		160,
		100
	)

	var preview_label := Label.new()

	preview_label.text = String(
		creature_data.id
	)

	preview_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	preview_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	preview.add_child(
		preview_label
	)

	return preview


func _refresh_visual() -> void:
	if name_label == null:
		return

	if category_label == null:
		return

	if creature_data == null:
		name_label.text = "NO CREATURE"
		category_label.text = ""
		return

	name_label.text = String(
		creature_data.id
	)

	category_label.text = _get_category_text(
		creature_data.category
	)


func _get_category_text(
	category: CreatureData.Category
) -> String:
	match category:
		CreatureData.Category.GOOD:
			return "GOOD"

		CreatureData.Category.NEUTRAL:
			return "NEUTRAL"

		CreatureData.Category.EVIL:
			return "EVIL"

		_:
			return "UNKNOWN"
