class_name TableHappinessResult
extends RefCounted


## Результаты по каждому месту за столом.
##
## Индекс массива соответствует индексу места.
var seat_results: Array[CreatureHappinessResult] = []


## Общее счастье всех существ.
var total_score: int = 0


## Количество уникальных критических пар.
var critical_pair_count: int = 0


## Пересчитывает общее счастье стола.
func recalculate_totals() -> void:
	total_score = 0

	for result: CreatureHappinessResult in seat_results:
		if result == null:
			continue

		total_score += result.total_score


## Среднее счастье одного существа.
func get_average_score() -> float:
	var occupied_seats: int = 0

	for result: CreatureHappinessResult in seat_results:
		if result != null:
			occupied_seats += 1

	if occupied_seats == 0:
		return 0.0

	return float(total_score) / float(occupied_seats)


## Получить результат конкретного места.
func get_result_for_seat(
	seat_index: int
) -> CreatureHappinessResult:
	if seat_index < 0:
		return null

	if seat_index >= seat_results.size():
		return null

	return seat_results[seat_index]


## Найти результат по ID существа.
func get_result_for_creature(
	creature_id: StringName
) -> CreatureHappinessResult:
	for result: CreatureHappinessResult in seat_results:
		if result == null:
			continue

		if result.creature_id == creature_id:
			return result

	return null
func get_occupied_seat_count() -> int:
	var count: int = 0

	for result: CreatureHappinessResult in seat_results:
		if result != null:
			count += 1

	return count
