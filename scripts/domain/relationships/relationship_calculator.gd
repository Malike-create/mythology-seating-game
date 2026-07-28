class_name RelationshipCalculator
extends RefCounted


const CRITICAL_CONFLICT_THRESHOLD: int = -4


var _ability_resolver: AbilityResolver


func _init() -> void:
	_ability_resolver = AbilityResolver.new()


## Рассчитывает отношения сразу в двух направлениях:
##
## first -> second
## second -> first
func evaluate_pair(
	first: CreatureData,
	second: CreatureData
) -> RelationshipPairResult:
	if first == null or second == null:
		push_error(
			"RelationshipCalculator received null CreatureData."
		)
		return RelationshipPairResult.new()

	if first.id == &"" or second.id == &"":
		push_error(
			"CreatureData must have a valid id."
		)
		return RelationshipPairResult.new()

	var first_to_second: RelationshipResult = _calculate_direction(
		first,
		second
	)

	var second_to_first: RelationshipResult = _calculate_direction(
		second,
		first
	)

	return RelationshipPairResult.new(
		first_to_second,
		second_to_first
	)


## Рассчитывает реакцию одного существа на другого.
func _calculate_direction(
	observer: CreatureData,
	neighbor: CreatureData
) -> RelationshipResult:
	var result := RelationshipResult.new(
		observer.id,
		neighbor.id
	)

	# 1. Базовое отношение категорий.
	result.category_score = _get_category_score(
		observer.category,
		neighbor.category
	)

	# 2. Ищем личное отношение.
	var personal_relation: CreatureRelationData = _find_relation(
		observer,
		neighbor.id
	)

	if (
		personal_relation != null
		and personal_relation.attitude
			== CreatureRelationData.Attitude.TOLERATE
	):
		# TOLERATE означает:
		# "я терплю этого соседа".
		#
		# Итог до способностей становится нейтральным.
		result.relationship_modifier = 0
		result.score_before_abilities = 0

	elif personal_relation != null:
		result.relationship_modifier = personal_relation.modifier

		result.score_before_abilities = (
			result.category_score
			+ result.relationship_modifier
		)

	else:
		# Нет отдельного отношения:
		# используем только базовое правило категорий.
		result.relationship_modifier = 0
		result.score_before_abilities = result.category_score

	# 3. Проверяем критический конфликт
	# ДО способностей.
	result.is_critical = (
		result.score_before_abilities
		<= CRITICAL_CONFLICT_THRESHOLD
	)

	# 4. До применения способностей final_score такой же.
	result.final_score = result.score_before_abilities

	# 5. Применяем способности.
	_ability_resolver.apply_directional_abilities(
		observer,
		neighbor,
		result
	)

	return result


## Ищет индивидуальное отношение observer к target.
func _find_relation(
	observer: CreatureData,
	target_id: StringName
) -> CreatureRelationData:
	for relation: CreatureRelationData in observer.relationships:
		if relation == null:
			continue

		if relation.target_creature_id == target_id:
			return relation

	return null


## Базовая таблица категорий.
func _get_category_score(
	first_category: int,
	second_category: int
) -> int:
	# Одинаковые категории.
	if first_category == second_category:
		match first_category:
			CreatureData.Category.GOOD:
				return 2

			CreatureData.Category.NEUTRAL:
				return 1

			CreatureData.Category.EVIL:
				return 2

	# GOOD + NEUTRAL
	if (
		(first_category == CreatureData.Category.GOOD
		and second_category == CreatureData.Category.NEUTRAL)
		or
		(first_category == CreatureData.Category.NEUTRAL
		and second_category == CreatureData.Category.GOOD)
	):
		return 1

	# NEUTRAL + EVIL
	if (
		(first_category == CreatureData.Category.NEUTRAL
		and second_category == CreatureData.Category.EVIL)
		or
		(first_category == CreatureData.Category.EVIL
		and second_category == CreatureData.Category.NEUTRAL)
	):
		return 0

	# GOOD + EVIL
	if (
		(first_category == CreatureData.Category.GOOD
		and second_category == CreatureData.Category.EVIL)
		or
		(first_category == CreatureData.Category.EVIL
		and second_category == CreatureData.Category.GOOD)
	):
		return -2

	push_warning(
		"Unknown category combination: %s / %s"
		% [first_category, second_category]
	)

	return 0
