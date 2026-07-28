extends Node


const LEVEL_01: LevelData = preload(
	"res://data/levels/level_01.tres"
)

const UMAI_ENE: CreatureData = preload(
	"res://data/creatures/umai_ene.tres"
)

const ALPAKARAKUSH: CreatureData = preload(
	"res://data/creatures/alpakarakush.tres"
)

const ALBARSTY: CreatureData = preload(
	"res://data/creatures/albarsty.tres"
)

const ZHELMOGUZ: CreatureData = preload(
	"res://data/creatures/zhelmoguz_kempir.tres"
)


func _ready() -> void:
	print("")
	print("====================================")
	print("HOST OBJECTIVE TEST")
	print("====================================")

	_test_failed_layout()
	_test_successful_layout()

	print("")
	print("ALL HOST OBJECTIVE TESTS PASSED!")


func _test_failed_layout() -> void:
	var seats: Array[CreatureData] = [
		UMAI_ENE,
		ALPAKARAKUSH,
		ALBARSTY,
		ZHELMOGUZ
	]

	var happiness_calculator := HappinessCalculator.new()
	var evaluator := HostObjectiveEvaluator.new()

	var table_result := happiness_calculator.evaluate_table(
		seats,
		false
	)

	var objective_result := evaluator.evaluate(
		LEVEL_01,
		table_result
	)

	print("")
	print("--- FAILED LAYOUT ---")
	print(
		"Happiness: ",
		table_result.total_score
	)
	print(
		"Critical: ",
		table_result.critical_pair_count
	)
	print(
		"Passed: ",
		objective_result.passed
	)

	assert(
		objective_result.passed == false,
		"This layout should fail."
	)


func _test_successful_layout() -> void:
	var seats: Array[CreatureData] = [
		UMAI_ENE,
		ALPAKARAKUSH,
		ZHELMOGUZ,
		ALBARSTY
	]

	var happiness_calculator := HappinessCalculator.new()
	var evaluator := HostObjectiveEvaluator.new()

	var table_result := happiness_calculator.evaluate_table(
		seats,
		false
	)

	var objective_result := evaluator.evaluate(
		LEVEL_01,
		table_result
	)

	print("")
	print("--- SUCCESSFUL LAYOUT ---")
	print(
		"Happiness: ",
		table_result.total_score
	)
	print(
		"Critical: ",
		table_result.critical_pair_count
	)
	print(
		"Passed: ",
		objective_result.passed
	)

	assert(
		table_result.total_score == 11,
		"Expected happiness 11."
	)

	assert(
		table_result.critical_pair_count == 0,
		"Expected zero critical conflicts."
	)

	assert(
		objective_result.passed == true,
		"This layout should pass."
	)
