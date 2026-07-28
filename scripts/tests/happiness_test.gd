extends Node


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
	print("HAPPINESS CALCULATOR TEST")
	print("====================================")

	_test_linear_table()
	_test_circular_table()

	print("")
	print("====================================")
	print("ALL HAPPINESS TESTS PASSED!")
	print("====================================")


func _test_linear_table() -> void:
	print("")
	print("--- LINEAR TABLE TEST ---")
	print("")

	var seats: Array[CreatureData] = [
		UMAI_ENE,
		ALPAKARAKUSH,
		ALBARSTY,
		ZHELMOGUZ
	]

	var calculator := HappinessCalculator.new()

	var result: TableHappinessResult = (
		calculator.evaluate_table(
			seats,
			false
		)
	)

	_print_table_result(result)

	var umai_result := result.get_result_for_creature(
		&"umai_ene"
	)

	var alpakarakush_result := result.get_result_for_creature(
		&"alpakarakush"
	)

	var albarsty_result := result.get_result_for_creature(
		&"albarsty"
	)

	var zhelmoguz_result := result.get_result_for_creature(
		&"zhelmoguz_kempir"
	)

	assert(
		umai_result.total_score == 3,
		"Linear: Umai-Ene happiness should be 3."
	)

	assert(
		alpakarakush_result.total_score == 0,
		"Linear: Alpakarakush happiness should be 0."
	)

	assert(
		albarsty_result.total_score == -1,
		"Linear: Albarsty happiness should be -1."
	)

	assert(
		zhelmoguz_result.total_score == 4,
		"Linear: Zhelmoguz happiness should be 4."
	)

	assert(
		result.total_score == 6,
		"Linear: total table score should be 6."
	)

	assert(
		result.critical_pair_count == 1,
		"Linear: critical pair count should be 1."
	)

	print("")
	print("LINEAR TABLE TEST PASSED!")


func _test_circular_table() -> void:
	print("")
	print("--- CIRCULAR TABLE TEST ---")
	print("")

	var seats: Array[CreatureData] = [
		UMAI_ENE,
		ALPAKARAKUSH,
		ALBARSTY,
		ZHELMOGUZ
	]

	var calculator := HappinessCalculator.new()

	var result: TableHappinessResult = (
		calculator.evaluate_table(
			seats,
			true
		)
	)

	_print_table_result(result)

	var umai_result := result.get_result_for_creature(
		&"umai_ene"
	)

	var alpakarakush_result := result.get_result_for_creature(
		&"alpakarakush"
	)

	var albarsty_result := result.get_result_for_creature(
		&"albarsty"
	)

	var zhelmoguz_result := result.get_result_for_creature(
		&"zhelmoguz_kempir"
	)

	assert(
		umai_result.total_score == -1,
		"Circular: Umai-Ene happiness should be -1."
	)

	assert(
		alpakarakush_result.total_score == 0,
		"Circular: Alpakarakush happiness should be 0."
	)

	assert(
		albarsty_result.total_score == -1,
		"Circular: Albarsty happiness should be -1."
	)

	assert(
		zhelmoguz_result.total_score == 1,
		"Circular: Zhelmoguz happiness should be 1."
	)

	assert(
		result.total_score == -1,
		"Circular: total table score should be -1."
	)

	assert(
		result.critical_pair_count == 2,
		"Circular: critical pair count should be 2."
	)

	print("")
	print("CIRCULAR TABLE TEST PASSED!")


func _print_table_result(
	result: TableHappinessResult
) -> void:
	for creature_result: CreatureHappinessResult in result.seat_results:
		if creature_result == null:
			continue

		print(
			"Seat ",
			creature_result.seat_index,
			" | ",
			creature_result.creature_id,
			" | Happiness: ",
			creature_result.total_score,
			" | Critical neighbor: ",
			creature_result.has_critical_neighbor
		)

	print("")
	print("TOTAL HAPPINESS: ", result.total_score)
	print("AVERAGE HAPPINESS: ", result.get_average_score())
	print(
		"CRITICAL PAIRS: ",
		result.critical_pair_count
	)
