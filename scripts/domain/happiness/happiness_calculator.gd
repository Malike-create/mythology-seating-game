class_name HappinessCalculator
extends RefCounted


var _relationship_calculator: RelationshipCalculator


func _init() -> void:
	_relationship_calculator = RelationshipCalculator.new()


## Рассчитывает счастье всех существ за столом.
##
## seats:
## массив существ в порядке расположения мест.
##
## Например:
##
## [
##     Умай,
##     Алпкаракуш,
##     Албарсты,
##     Желмогуз
## ]
##
## wrap_around:
##
## false:
## первый и последний НЕ соседи.
##
## true:
## первый и последний тоже считаются соседями,
## то есть стол становится круговым.
func evaluate_table(
	seats: Array[CreatureData],
	wrap_around: bool = false
) -> TableHappinessResult:
	var table_result := TableHappinessResult.new()

	table_result.seat_results.resize(seats.size())

	# Сначала создаём пустой результат
	# для каждого занятого места.
	for seat_index: int in range(seats.size()):
		var creature: CreatureData = seats[seat_index]

		if creature == null:
			continue

		table_result.seat_results[seat_index] = (
			CreatureHappinessResult.new(
				creature.id,
				seat_index
			)
		)

	# Если существ меньше двух,
	# никаких отношений считать не нужно.
	if seats.size() < 2:
		_recalculate_creatures(table_result)
		table_result.recalculate_totals()

		return table_result

	# Считаем обычные соседние пары:
	#
	# 0 ↔ 1
	# 1 ↔ 2
	# 2 ↔ 3
	for seat_index: int in range(seats.size() - 1):
		_evaluate_neighbor_pair(
			seat_index,
			seat_index + 1,
			seats,
			table_result
		)

	# Для круглого стола дополнительно:
	#
	# последний ↔ первый
	#
	# Проверяем size > 2, чтобы при двух существах
	# не посчитать одну и ту же пару дважды.
	if wrap_around and seats.size() > 2:
		_evaluate_neighbor_pair(
			seats.size() - 1,
			0,
			seats,
			table_result
		)

	# Теперь каждое существо суммирует
	# левое и правое отношение.
	_recalculate_creatures(table_result)

	# И наконец считаем весь стол.
	table_result.recalculate_totals()

	return table_result


## Рассчитывает одну соседнюю пару
## и распределяет направленные результаты
## между двумя существами.
func _evaluate_neighbor_pair(
	left_index: int,
	right_index: int,
	seats: Array[CreatureData],
	table_result: TableHappinessResult
) -> void:
	var left_creature: CreatureData = seats[left_index]
	var right_creature: CreatureData = seats[right_index]

	# Пустое место не создаёт отношений.
	if left_creature == null or right_creature == null:
		return

	var pair: RelationshipPairResult = (
		_relationship_calculator.evaluate_pair(
			left_creature,
			right_creature
		)
	)

	var left_result: CreatureHappinessResult = (
		table_result.seat_results[left_index]
	)

	var right_result: CreatureHappinessResult = (
		table_result.seat_results[right_index]
	)

	if left_result == null or right_result == null:
		push_error(
			"HappinessCalculator could not find seat result."
		)
		return

	# Левое существо смотрит на правого соседа.
	left_result.right_relationship = pair.first_to_second

	# Правое существо смотрит на левого соседа.
	right_result.left_relationship = pair.second_to_first

	# Пару считаем критической только один раз,
	# независимо от того, одна или обе стороны
	# имеют критическую реакцию.
	if pair.has_critical_conflict():
		table_result.critical_pair_count += 1


func _recalculate_creatures(
	table_result: TableHappinessResult
) -> void:
	for result: CreatureHappinessResult in table_result.seat_results:
		if result == null:
			continue

		result.recalculate()
