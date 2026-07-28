extends Node


const UMAI_ENE: CreatureData = preload(
	"res://data/creatures/umai_ene.tres"
)

const ALBARSTY: CreatureData = preload(
	"res://data/creatures/albarsty.tres"
)


func _ready() -> void:
	print("")
	print("====================================")
	print("RELATIONSHIP TEST")
	print("====================================")

	_test_umai_ene_and_albarsty()

	print("====================================")
	print("TEST FINISHED")
	print("====================================")


func _test_umai_ene_and_albarsty() -> void:
	var calculator := RelationshipCalculator.new()

	var pair: RelationshipPairResult = calculator.evaluate_pair(
		UMAI_ENE,
		ALBARSTY
	)

	if pair.first_to_second == null:
		push_error("First relationship result is null.")
		return

	if pair.second_to_first == null:
		push_error("Second relationship result is null.")
		return

	print("")
	print("PAIR: umai_ene <-> albarsty")
	print("")

	print("--- Umai-Ene -> Albarsty ---")
	_print_result(pair.first_to_second)

	print("")
	print("--- Albarsty -> Umai-Ene ---")
	_print_result(pair.second_to_first)

	print("")
	print("Pair total score: ", pair.get_total_score())
	print(
		"Critical conflict: ",
		pair.has_critical_conflict()
	)

	print("")
	print("--- EXPECTED VALUES ---")
	print("Umai-Ene -> Albarsty = -5")
	print("Albarsty -> Umai-Ene = -3")
	print("Critical conflict = true")

	assert(
		pair.first_to_second.final_score == -5,
		"Unexpected Umai-Ene -> Albarsty score."
	)

	assert(
		pair.second_to_first.final_score == -3,
		"Unexpected Albarsty -> Umai-Ene score."
	)

	assert(
		pair.has_critical_conflict() == true,
		"Pair should be a critical conflict."
	)

	print("")
	print("TEST PASSED!")


func _print_result(result: RelationshipResult) -> void:
	print("Observer: ", result.observer_id)
	print("Neighbor: ", result.neighbor_id)
	print("Category score: ", result.category_score)
	print(
		"Relationship modifier: ",
		result.relationship_modifier
	)
	print(
		"Score before abilities: ",
		result.score_before_abilities
	)
	print(
		"Ability modifier total: ",
		result.get_ability_total()
	)
	print("Final score: ", result.final_score)
	print("Critical: ", result.is_critical)
