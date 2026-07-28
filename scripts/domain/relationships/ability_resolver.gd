class_name AbilityResolver
extends RefCounted


func apply_directional_abilities(
	observer: CreatureData,
	neighbor: CreatureData,
	result: RelationshipResult
) -> void:
	if observer == null or neighbor == null or result == null:
		push_error("AbilityResolver received invalid data.")
		return

	# Сначала применяем способность соседа,
	# если она воздействует на observer.
	_apply_neighbor_ability(observer, neighbor, result)

	# Затем применяем собственную способность observer.
	_apply_observer_ability(observer, neighbor, result)


func _apply_neighbor_ability(
	observer: CreatureData,
	neighbor: CreatureData,
	result: RelationshipResult
) -> void:
	var ability: AbilityData = neighbor.ability

	if ability == null:
		return

	if ability.target != AbilityData.TargetType.NEIGHBORS:
		return

	match ability.type:
		AbilityData.AbilityType.ADJACENT_HAPPINESS_BONUS:
			result.add_ability_modifier(
				neighbor.id,
				ability.amount,
				&"adjacent_happiness_bonus"
			)

		AbilityData.AbilityType.ADJACENT_CATEGORY_BONUS:
			if observer.category == ability.target_category:
				result.add_ability_modifier(
					neighbor.id,
					ability.amount,
					&"adjacent_category_bonus"
				)

		AbilityData.AbilityType.ADJACENT_CATEGORY_PENALTY:
			if observer.category == ability.target_category:
				result.add_ability_modifier(
					neighbor.id,
					ability.amount,
					&"adjacent_category_penalty"
				)

		_:
			pass


func _apply_observer_ability(
	observer: CreatureData,
	neighbor: CreatureData,
	result: RelationshipResult
) -> void:
	var ability: AbilityData = observer.ability

	if ability == null:
		return

	if ability.target != AbilityData.TargetType.SELF:
		return

	match ability.type:
		AbilityData.AbilityType.SELF_BONUS_PER_CATEGORY:
			if neighbor.category == ability.target_category:
				result.add_ability_modifier(
					observer.id,
					ability.amount,
					&"self_bonus_per_category"
				)

		AbilityData.AbilityType.AMPLIFY_POSITIVE_BONUS:
			if (
				neighbor.category == ability.target_category
				and result.final_score > 0
			):
				result.add_ability_modifier(
					observer.id,
					ability.amount,
					&"amplify_positive_bonus"
				)

		AbilityData.AbilityType.REDUCE_NEGATIVE_PENALTY:
			_apply_negative_penalty_reduction(
				observer,
				ability,
				result
			)

		AbilityData.AbilityType.IGNORE_ALIGNMENT_PENALTY:
			_apply_alignment_penalty_immunity(
				observer,
				result
			)

		_:
			pass


func _apply_negative_penalty_reduction(
	observer: CreatureData,
	ability: AbilityData,
	result: RelationshipResult
) -> void:
	if result.final_score >= 0:
		return

	var requested_amount: int = max(ability.amount, 0)

	if requested_amount == 0:
		return

	var actual_amount: int = min(
		requested_amount,
		abs(result.final_score)
	)

	result.add_ability_modifier(
		observer.id,
		actual_amount,
		&"reduce_negative_penalty"
	)


func _apply_alignment_penalty_immunity(
	observer: CreatureData,
	result: RelationshipResult
) -> void:
	# Убираем только отрицательный штраф,
	# который появился из-за категории.
	#
	# Личная неприязнь при этом остаётся.
	if result.category_score >= 0:
		return

	var compensation: int = abs(result.category_score)

	result.add_ability_modifier(
		observer.id,
		compensation,
		&"ignore_alignment_penalty"
	)
