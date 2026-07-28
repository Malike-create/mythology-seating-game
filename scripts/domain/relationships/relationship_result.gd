class_name RelationshipResult
extends RefCounted


## Существо, чью реакцию мы рассчитываем.
var observer_id: StringName = &""

## Существо, на которое оно реагирует.
var neighbor_id: StringName = &""


## Базовый результат от категорий.
##
## Например:
## GOOD + GOOD = +2
## GOOD + EVIL = -2
var category_score: int = 0


## Личное отношение.
##
## LIKE = +1
## DISLIKE = -2
## NEUTRAL = 0
## TOLERATE = 0
var relationship_modifier: int = 0


## Результат до применения способностей.
var score_before_abilities: int = 0


## Все изменения, которые внесли способности.
var ability_modifiers: Array[Dictionary] = []


## Финальное значение.
var final_score: int = 0


## Является ли соседство критическим конфликтом.
var is_critical: bool = false


func _init(
	p_observer_id: StringName = &"",
	p_neighbor_id: StringName = &""
) -> void:
	observer_id = p_observer_id
	neighbor_id = p_neighbor_id


func add_ability_modifier(
	source_id: StringName,
	amount: int,
	description: StringName
) -> void:
	if amount == 0:
		return

	ability_modifiers.append({
		"source_id": source_id,
		"amount": amount,
		"description": description
	})

	final_score += amount


func get_ability_total() -> int:
	var total: int = 0

	for modifier: Dictionary in ability_modifiers:
		total += int(modifier.get("amount", 0))

	return total
