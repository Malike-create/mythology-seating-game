class_name LevelSceneBuilder
extends Node


@export_category("Reusable Scenes")

## Готовая сцена одного места за столом.
@export var seat_slot_scene: PackedScene

## Готовая сцена одной карточки существа.
@export var creature_card_scene: PackedScene


@export_category("Target Containers")

## Контейнер, куда будут добавляться места.
@export var seats_container: Control

## Контейнер, куда будут добавляться карточки.
@export var cards_container: Control


## Полностью создаёт содержимое уровня из LevelData.
func build_level(level_data: LevelData) -> bool:
	if level_data == null:
		push_error(
			"LevelSceneBuilder: level_data is null."
		)
		return false

	if seat_slot_scene == null:
		push_error(
			"LevelSceneBuilder: seat_slot_scene is not assigned."
		)
		return false

	if creature_card_scene == null:
		push_error(
			"LevelSceneBuilder: creature_card_scene is not assigned."
		)
		return false

	if seats_container == null:
		push_error(
			"LevelSceneBuilder: seats_container is not assigned."
		)
		return false

	if cards_container == null:
		push_error(
			"LevelSceneBuilder: cards_container is not assigned."
		)
		return false

	if level_data.creatures.size() > level_data.seat_count:
		push_error(
			"LevelSceneBuilder: level has more creatures than seats."
		)
		return false

	_clear_container(seats_container)
	_clear_container(cards_container)

	_create_seats(level_data.seat_count)
	_create_cards(level_data.creatures)

	print("")
	print("====================================")
	print("LEVEL CONTENT GENERATED")
	print("====================================")
	print("Level: ", level_data.id)
	print("Seats created: ", level_data.seat_count)
	print("Cards created: ", level_data.creatures.size())

	return true


func _create_seats(
	seat_count: int
) -> void:
	for seat_index: int in range(seat_count):
		var instance: Node = seat_slot_scene.instantiate()

		if not instance is SeatSlot:
			push_error(
				"LevelSceneBuilder: seat_slot_scene root must be SeatSlot."
			)
			instance.free()
			continue

		var slot: SeatSlot = instance as SeatSlot

		slot.name = "SeatSlot_%02d" % seat_index
		slot.seat_index = seat_index

		seats_container.add_child(slot)


func _create_cards(
	creatures: Array[CreatureData]
) -> void:
	for creature: CreatureData in creatures:
		if creature == null:
			push_warning(
				"LevelSceneBuilder: empty creature found in LevelData."
			)
			continue

		var instance: Node = creature_card_scene.instantiate()

		if not instance is CreatureCard:
			push_error(
				"LevelSceneBuilder: creature_card_scene root must be CreatureCard."
			)
			instance.free()
			continue

		var card: CreatureCard = instance as CreatureCard

		card.name = "CreatureCard_" + String(creature.id)

		cards_container.add_child(card)
		card.set_creature(creature)


func _clear_container(
	container: Node
) -> void:
	for child: Node in container.get_children():
		container.remove_child(child)
		child.queue_free()
