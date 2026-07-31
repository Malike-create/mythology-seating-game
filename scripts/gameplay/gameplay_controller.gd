class_name GameplayController
extends Node


@export_category("Level")

@export var level_data: LevelData


@export_category("Controllers")

@export var level_scene_builder: LevelSceneBuilder
@export var placement_controller: PlacementController


@export_category("UI")

@export var host_label: Label
@export var objective_label: Label

@export var total_happiness_label: Label
@export var critical_conflicts_label: Label

@export var submit_button: Button
@export var result_label: Label


var _happiness_calculator: HappinessCalculator
var _objective_evaluator: HostObjectiveEvaluator

var _current_table_result: TableHappinessResult


func _ready() -> void:
	if GameSession.has_selected_level():
		level_data = GameSession.selected_level

		print(
			"Gameplay received selected level: ",
			level_data.id
		)

	elif level_data != null:
		print(
			"Gameplay uses Inspector level: ",
			level_data.id
		)
	_happiness_calculator = HappinessCalculator.new()
	_objective_evaluator = HostObjectiveEvaluator.new()

	if not _validate_dependencies():
		return

	## Сначала создаём визуальные объекты уровня.
	var level_built: bool = (
		level_scene_builder.build_level(
			level_data
		)
	)

	if not level_built:
		return

	## После создания карточек и мест
	## PlacementController собирает их в свои массивы.
	var placement_initialized: bool = (
		placement_controller.initialize()
	)

	if not placement_initialized:
		return

	if not placement_controller.placement_changed.is_connected(
		_on_placement_changed
	):
		placement_controller.placement_changed.connect(
			_on_placement_changed
		)

	if (
		submit_button != null
		and not submit_button.pressed.is_connected(
			_on_submit_pressed
		)
	):
		submit_button.pressed.connect(
			_on_submit_pressed
		)

	_refresh_level_ui()
	_refresh_happiness()


func _validate_dependencies() -> bool:
	if level_data == null:
		push_error(
			"GameplayController: level_data is not assigned."
		)
		return false

	if level_scene_builder == null:
		push_error(
			"GameplayController: level_scene_builder is not assigned."
		)
		return false

	if placement_controller == null:
		push_error(
			"GameplayController: placement_controller is not assigned."
		)
		return false

	return true


func _on_placement_changed() -> void:
	if result_label != null:
		result_label.text = ""

	_refresh_happiness()


func _refresh_level_ui() -> void:
	if level_data == null:
		return

	if host_label != null:
		if level_data.host != null:
			host_label.text = (
				"Host: "
				+ String(level_data.host.id)
			)
		else:
			host_label.text = "Host: NONE"

	if objective_label != null:
		objective_label.text = (
			"Goal: Happiness >= "
			+ str(level_data.required_happiness)
			+ " | Critical Conflicts <= "
			+ str(level_data.max_critical_conflicts)
		)


func _refresh_happiness() -> void:
	if placement_controller == null:
		return

	if level_data == null:
		return

	var placements: Array[CreatureData] = (
		placement_controller.get_placements()
	)

	_current_table_result = (
		_happiness_calculator.evaluate_table(
			placements,
			level_data.wrap_around
		)
	)

	_refresh_global_ui(
		_current_table_result
	)

	_refresh_seat_ui(
		_current_table_result
	)

	_print_debug_result(
		_current_table_result
	)


func _refresh_global_ui(
	result: TableHappinessResult
) -> void:
	if total_happiness_label != null:
		total_happiness_label.text = (
			"Total Happiness: "
			+ str(result.total_score)
		)

	if critical_conflicts_label != null:
		critical_conflicts_label.text = (
			"Critical Conflicts: "
			+ str(result.critical_pair_count)
		)


func _refresh_seat_ui(
	result: TableHappinessResult
) -> void:
	var slots: Array[SeatSlot] = (
		placement_controller.get_slots()
	)

	for seat_index: int in range(
		slots.size()
	):
		var slot: SeatSlot = slots[seat_index]

		if slot == null:
			continue

		var creature_result: CreatureHappinessResult = (
			result.get_result_for_seat(
				seat_index
			)
		)

		slot.set_happiness_result(
			creature_result
		)


func _on_submit_pressed() -> void:
	if level_data == null:
		return

	if _current_table_result == null:
		return

	var objective_result: HostObjectiveResult = (
		_objective_evaluator.evaluate(
			level_data,
			_current_table_result
		)
	)

	if result_label != null:
		result_label.text = (
			objective_result.get_status_text()
		)

	print("")
	print("====================================")
	print("LEVEL CHECK")
	print("====================================")

	print(
		"All seats filled: ",
		objective_result.all_seats_filled
	)

	print(
		"Happiness met: ",
		objective_result.happiness_met
	)

	print(
		"Conflicts met: ",
		objective_result.conflicts_met
	)

	print(
		"LEVEL PASSED: ",
		objective_result.passed
	)


func _print_debug_result(
	result: TableHappinessResult
) -> void:
	print("")
	print("--- CURRENT TABLE ---")

	for creature_result: CreatureHappinessResult in result.seat_results:
		if creature_result == null:
			continue

		print(
			"Seat ",
			creature_result.seat_index,
			" | ",
			creature_result.creature_id,
			" | Happiness: ",
			creature_result.total_score
		)

	print(
		"TOTAL HAPPINESS: ",
		result.total_score
	)

	print(
		"CRITICAL CONFLICTS: ",
		result.critical_pair_count
	)
