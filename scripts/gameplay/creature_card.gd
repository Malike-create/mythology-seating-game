class_name CreatureCard
extends PanelContainer


## Данные существа этой карточки.
@export var creature_data: CreatureData


@onready var portrait_rect: TextureRect = (
	$VBoxContainer/PortraitRect
)

@onready var name_label: Label = (
	$VBoxContainer/NameLabel
)

@onready var category_label: Label = (
	$VBoxContainer/CategoryLabel
)


func _ready() -> void:
	custom_minimum_size = Vector2(
		180,
		180
	)

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

	if (
		creature_data != null
		and creature_data.portrait != null
	):
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

	preview_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	preview_vbox.add_child(
		preview_label
	)

	return preview


func _refresh_visual() -> void:
	if portrait_rect == null:
		return

	if name_label == null:
		return

	if category_label == null:
		return

	if creature_data == null:
		portrait_rect.texture = null
		name_label.text = "NO CREATURE"
		category_label.text = ""
		return

	portrait_rect.texture = creature_data.portrait

	name_label.text = _get_display_name()

	category_label.text = _get_category_text(
		creature_data.category
	)


func _get_display_name() -> String:
	if creature_data == null:
		return "NO CREATURE"

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


func _get_category_text(
	category: CreatureData.Category
) -> String:
	match category:
		CreatureData.Category.GOOD:
			return tr("category.good")

		CreatureData.Category.NEUTRAL:
			return tr("category.neutral")

		CreatureData.Category.EVIL:
			return tr("category.evil")

		_:
			return "UNKNOWN"
