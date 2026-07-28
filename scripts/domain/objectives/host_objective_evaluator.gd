class_name HostObjectiveEvaluator
extends RefCounted


func evaluate(
	level_data: LevelData,
	table_result: TableHappinessResult
) -> HostObjectiveResult:
	var result := HostObjectiveResult.new()

	if level_data == null:
		push_error(
			"HostObjectiveEvaluator: level_data is null."
		)
		return result

	if level_data.host == null:
		push_error(
			"HostObjectiveEvaluator: level has no host."
		)
		return result

	if table_result == null:
		push_error(
			"HostObjectiveEvaluator: table_result is null."
		)
		return result

	result.total_happiness = table_result.total_score

	result.critical_conflicts = (
		table_result.critical_pair_count
	)

	result.all_seats_filled = (
		table_result.get_occupied_seat_count()
		>= level_data.seat_count
	)

	match level_data.host.objective_type:
		HostData.ObjectiveType.HARMONY:
			_evaluate_harmony(
				level_data,
				result
			)

		HostData.ObjectiveType.DISCORD:
			push_warning(
				"Discord objective is not implemented yet."
			)

		HostData.ObjectiveType.NATURE:
			push_warning(
				"Nature objective is not implemented yet."
			)

	return result


func _evaluate_harmony(
	level_data: LevelData,
	result: HostObjectiveResult
) -> void:
	result.happiness_met = (
		result.total_happiness
		>= level_data.required_happiness
	)

	result.conflicts_met = (
		result.critical_conflicts
		<= level_data.max_critical_conflicts
	)

	result.passed = (
		result.all_seats_filled
		and result.happiness_met
		and result.conflicts_met
	)
