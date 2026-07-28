class_name CreatureHappinessResult
extends RefCounted


## ID существа.
var creature_id: StringName = &""

## На каком месте за столом сидит существо.
var seat_index: int = -1


## Реакция существа на соседа слева.
var left_relationship: RelationshipResult


## Реакция существа на соседа справа.
var right_relationship: RelationshipResult


## Итоговое счастье существа.
var total_score: int = 0


## Есть ли хотя бы один критический сосед.
var has_critical_neighbor: bool = false


func _init(
	p_creature_id: StringName = &"",
	p_seat_index: int = -1
) -> void:
	creature_id = p_creature_id
	seat_index = p_seat_index


## Пересчитывает итог после того,
## как назначены левый и правый соседи.
func recalculate() -> void:
	total_score = 0
	has_critical_neighbor = false

	if left_relationship != null:
		total_score += left_relationship.final_score

		if left_relationship.is_critical:
			has_critical_neighbor = true

	if right_relationship != null:
		total_score += right_relationship.final_score

		if right_relationship.is_critical:
			has_critical_neighbor = true
