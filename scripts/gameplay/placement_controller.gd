class_name PlacementController
extends Node


## Сообщаем другим системам, что рассадка изменилась.
signal placement_changed


## Контейнер со всеми SeatSlot.
@export var seats_container: Control

## Контейнер с карточками существ.
@export var cards_container: Control


var _slots: Array[SeatSlot] = []
var _placements: Array[CreatureData] = []

## creature_id → CreatureCard
var _cards_by_id: Dictionary = {}


func _ready() -> void:
	## Инициализацию запускает GameplayController
	## после создания мест и карточек.
	pass


func initialize() -> bool:
	if seats_container == null:
		push_error(
			"PlacementController: seats_container is not assigned."
		)
		return false

	if cards_container == null:
		push_error(
			"PlacementController: cards_container is not assigned."
		)
		return false

	_collect_slots()
	_collect_cards()
	_create_placement_array()

	print("")
	print("PLACEMENT CONTROLLER INITIALIZED")
	print("Slots found: ", _slots.size())
	print("Cards found: ", _cards_by_id.size())

	return true


func _collect_slots() -> void:
	_slots.clear()

	for child: Node in seats_container.get_children():
		if not child is SeatSlot:
			continue

		var slot: SeatSlot = child

		## Нумеруем места автоматически.
		slot.seat_index = _slots.size()

		if not slot.creature_dropped.is_connected(
			_on_creature_dropped
		):
			slot.creature_dropped.connect(
				_on_creature_dropped
			)

		_slots.append(slot)


func _collect_cards() -> void:
	_cards_by_id.clear()

	for child: Node in cards_container.get_children():
		if not child is CreatureCard:
			continue

		var card: CreatureCard = child

		if card.creature_data == null:
			continue

		_cards_by_id[card.creature_data.id] = card


func _create_placement_array() -> void:
	_placements.clear()
	_placements.resize(_slots.size())


func _on_creature_dropped(
	drag_data: Dictionary,
	target_seat_index: int
) -> void:
	if target_seat_index < 0:
		return

	if target_seat_index >= _slots.size():
		return

	var creature: CreatureData = (
		drag_data.get("creature_data") as CreatureData
	)

	if creature == null:
		return

	var target_slot: SeatSlot = _slots[target_seat_index]

	## Кто уже сидел на целевом месте.
	var displaced_creature: CreatureData = (
		target_slot.creature_data
	)

	## Откуда было взято существо.
	## -1 означает, что оно пришло из руки.
	var source_seat_index: int = int(
		drag_data.get(
			"source_seat_index",
			-1
		)
	)

	## Если существо бросили на то же самое место,
	## ничего не меняем.
	if source_seat_index == target_seat_index:
		return

	## Ищем, не сидит ли это существо
	## на другом месте.
	var existing_seat_index: int = (
		_find_creature_seat(creature.id)
	)

	## Освобождаем старое место.
	if (
		existing_seat_index >= 0
		and existing_seat_index != target_seat_index
	):
		_slots[existing_seat_index].clear_slot()
		_placements[existing_seat_index] = null

	## Если целевое место было занято другим существом,
	## возвращаем карточку вытесненного существа в руку.
	if (
		displaced_creature != null
		and displaced_creature.id != creature.id
	):
		_show_card(displaced_creature.id)

	## Сажаем новое существо.
	target_slot.set_creature(creature)
	_placements[target_seat_index] = creature

	## Убираем его карточку из руки.
	_hide_card(creature.id)

	placement_changed.emit()


func _find_creature_seat(
	creature_id: StringName
) -> int:
	for index: int in range(_placements.size()):
		var creature: CreatureData = _placements[index]

		if creature == null:
			continue

		if creature.id == creature_id:
			return index

	return -1


func _hide_card(
	creature_id: StringName
) -> void:
	if not _cards_by_id.has(creature_id):
		return

	var card: CreatureCard = _cards_by_id[creature_id]
	card.visible = false


func _show_card(
	creature_id: StringName
) -> void:
	if not _cards_by_id.has(creature_id):
		return

	var card: CreatureCard = _cards_by_id[creature_id]
	card.visible = true


func get_placements() -> Array[CreatureData]:
	return _placements


func get_slots() -> Array[SeatSlot]:
	return _slots
