class_name RelationshipPairResult
extends RefCounted


## Реакция первого существа на второго.
var first_to_second: RelationshipResult


## Реакция второго существа на первого.
var second_to_first: RelationshipResult


func _init(
	p_first_to_second: RelationshipResult = null,
	p_second_to_first: RelationshipResult = null
) -> void:
	first_to_second = p_first_to_second
	second_to_first = p_second_to_first


## Общая сумма двух направленных реакций.
func get_total_score() -> int:
	var total: int = 0

	if first_to_second != null:
		total += first_to_second.final_score

	if second_to_first != null:
		total += second_to_first.final_score

	return total


## Если хотя бы одна сторона имеет критический конфликт,
## вся пара считается критической.
func has_critical_conflict() -> bool:
	if first_to_second != null and first_to_second.is_critical:
		return true

	if second_to_first != null and second_to_first.is_critical:
		return true

	return false
