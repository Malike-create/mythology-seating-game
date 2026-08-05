class_name GameplayController
extends Node


const LEVEL_SELECT_SCENE_PATH: String = (
	"res://scenes/level_select/level_select.tscn"
)

const GAMEPLAY_SCENE_PATH: String = (
	"res://scenes/gameplay/gameplay.tscn"
)

const LEVEL_02: LevelData = preload(
	"res://data/levels/level_02.tres"
)


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


@onready var result_overlay: ColorRect = (
	$"../ResultOverlay"
)

@onready var result_center_container: CenterContainer = (
	$"../ResultOverlay/CenterContainer"
)

@onready var result_panel: PanelContainer = (
	$"../ResultOverlay/CenterContainer/ResultPanel"
)

@onready var result_vbox: VBoxContainer = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox"
)

@onready var result_title_label: Label = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ResultTitleLabel"
)

@onready var result_details_label: Label = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ResultDetailsLabel"
)

@onready var buttons_row: HBoxContainer = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ButtonsRow"
)

@onready var next_level_button: Button = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ButtonsRow/NextLevelButton"
)

@onready var retry_button: Button = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ButtonsRow/RetryButton"
)

@onready var result_back_button: Button = (
	$"../ResultOverlay/CenterContainer/ResultPanel/ResultVBox/ButtonsRow/BackButton"
)


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

	var level_built: bool = (
		level_scene_builder.build_level(
			level_data
		)
	)

	if not level_built:
		return

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

	_connect_result_buttons()
	_configure_interface()
	_configure_result_overlay()

	_refresh_level_ui()
	_refresh_happiness()

	print("GAMEPLAY HUD READY")
	print("RESULT OVERLAY READY")


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


func _configure_interface() -> void:
	if host_label != null:
		host_label.visible = true

	if objective_label != null:
		objective_label.visible = true
		objective_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)

	if total_happiness_label != null:
		total_happiness_label.visible = true

	if critical_conflicts_label != null:
		critical_conflicts_label.visible = true

	if submit_button != null:
		submit_button.visible = true
		submit_button.disabled = true
		submit_button.text = "CHECK RESULT"
		submit_button.focus_mode = Control.FOCUS_ALL

	if result_label != null:
		result_label.visible = true
		result_label.text = ""
		result_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)


func _configure_result_overlay() -> void:
	result_overlay.visible = false
	result_overlay.color = Color(
		0.0,
		0.0,
		0.0,
		0.75
	)

	result_overlay.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)

	result_overlay.z_index = 200

	result_overlay.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	result_center_container.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	result_panel.custom_minimum_size = Vector2(
		540.0,
		330.0
	)

	result_vbox.custom_minimum_size = Vector2(
		500.0,
		290.0
	)

	result_vbox.add_theme_constant_override(
		"separation",
		18
	)

	result_title_label.text = "LEVEL RESULT"

	result_title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	result_title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	result_title_label.add_theme_font_size_override(
		"font_size",
		32
	)

	result_details_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	result_details_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	result_details_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)

	result_details_label.custom_minimum_size = Vector2(
		480.0,
		150.0
	)

	result_details_label.add_theme_font_size_override(
		"font_size",
		20
	)

	buttons_row.alignment = (
		BoxContainer.ALIGNMENT_CENTER
	)

	buttons_row.add_theme_constant_override(
		"separation",
		12
	)

	next_level_button.text = "NEXT LEVEL"
	retry_button.text = "RETRY"
	result_back_button.text = "BACK TO LEVELS"

	next_level_button.custom_minimum_size = Vector2(
		150.0,
		52.0
	)

	retry_button.custom_minimum_size = Vector2(
		120.0,
		52.0
	)

	result_back_button.custom_minimum_size = Vector2(
		170.0,
		52.0
	)

	next_level_button.focus_mode = Control.FOCUS_ALL
	retry_button.focus_mode = Control.FOCUS_ALL
	result_back_button.focus_mode = Control.FOCUS_ALL


func _connect_result_buttons() -> void:
	if not next_level_button.pressed.is_connected(
		_on_next_level_pressed
	):
		next_level_button.pressed.connect(
			_on_next_level_pressed
		)

	if not retry_button.pressed.is_connected(
		_on_retry_pressed
	):
		retry_button.pressed.connect(
			_on_retry_pressed
		)

	if not result_back_button.pressed.is_connected(
		_on_result_back_pressed
	):
		result_back_button.pressed.connect(
			_on_result_back_pressed
		)


func _on_placement_changed() -> void:
	if result_overlay.visible:
		result_overlay.visible = false

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
				+ _format_display_name(
					String(level_data.host.id)
				)
			)
		else:
			host_label.text = "Host: None"

	if objective_label != null:
		objective_label.text = (
			"Goal:\n"
			+ "Happiness >= "
			+ str(level_data.required_happiness)
			+ "\nCritical Conflicts <= "
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
		_current_table_result,
		placements
	)

	_refresh_seat_ui(
		_current_table_result
	)

	_print_debug_result(
		_current_table_result
	)


func _refresh_global_ui(
	result: TableHappinessResult,
	placements: Array[CreatureData]
) -> void:
	var filled_seats: int = (
		_count_filled_seats(
			placements
		)
	)

	var total_seats: int = placements.size()

	var all_seats_filled: bool = (
		total_seats > 0
		and filled_seats == total_seats
	)

	if total_happiness_label != null:
		total_happiness_label.text = (
			"Happiness: "
			+ str(result.total_score)
			+ " / "
			+ str(level_data.required_happiness)
		)

	if critical_conflicts_label != null:
		critical_conflicts_label.text = (
			"Critical Conflicts: "
			+ str(result.critical_pair_count)
			+ " / "
			+ str(level_data.max_critical_conflicts)
		)

	if submit_button != null:
		submit_button.disabled = not all_seats_filled

		if all_seats_filled:
			submit_button.text = "CHECK RESULT"
		else:
			submit_button.text = (
				"CHECK RESULT ("
				+ str(filled_seats)
				+ "/"
				+ str(total_seats)
				+ " SEATS)"
			)

	if (
		result_label != null
		and result_label.text.is_empty()
	):
		if all_seats_filled:
			result_label.text = (
				"All seats are filled. "
				+ "Press CHECK RESULT."
			)
		else:
			result_label.text = (
				"Place all creatures. Seats filled: "
				+ str(filled_seats)
				+ " / "
				+ str(total_seats)
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

	_show_objective_result(
		objective_result
	)

	_show_result_overlay(
		objective_result
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


func _show_objective_result(
	objective_result: HostObjectiveResult
) -> void:
	if result_label == null:
		return

	if objective_result.passed:
		result_label.text = (
			"LEVEL COMPLETE!\n"
			+ "Happiness: "
			+ str(_current_table_result.total_score)
			+ " / "
			+ str(level_data.required_happiness)
			+ "\nCritical Conflicts: "
			+ str(_current_table_result.critical_pair_count)
			+ " / "
			+ str(level_data.max_critical_conflicts)
		)

		return

	var failure_reasons: PackedStringArray = []

	if not objective_result.all_seats_filled:
		failure_reasons.append(
			"Fill all seats."
		)

	if not objective_result.happiness_met:
		failure_reasons.append(
			"Not enough happiness."
		)

	if not objective_result.conflicts_met:
		failure_reasons.append(
			"Too many critical conflicts."
		)

	result_label.text = (
		"LEVEL NOT COMPLETE\n"
		+ "\n".join(failure_reasons)
		+ "\nHappiness: "
		+ str(_current_table_result.total_score)
		+ " / "
		+ str(level_data.required_happiness)
		+ "\nCritical Conflicts: "
		+ str(_current_table_result.critical_pair_count)
		+ " / "
		+ str(level_data.max_critical_conflicts)
	)


func _show_result_overlay(
	objective_result: HostObjectiveResult
) -> void:
	var details: PackedStringArray = []

	details.append(
		"Happiness: "
		+ str(_current_table_result.total_score)
		+ " / "
		+ str(level_data.required_happiness)
	)

	details.append(
		"Critical Conflicts: "
		+ str(_current_table_result.critical_pair_count)
		+ " / "
		+ str(level_data.max_critical_conflicts)
	)

	if objective_result.passed:
		result_title_label.text = (
			"LEVEL COMPLETE!"
		)

		details.append("")
		details.append(
			"The host is satisfied."
		)
	else:
		result_title_label.text = (
			"LEVEL NOT COMPLETE"
		)

		details.append("")

		if not objective_result.happiness_met:
			details.append(
				"Not enough happiness."
			)

		if not objective_result.conflicts_met:
			details.append(
				"Too many critical conflicts."
			)

	result_details_label.text = (
		"\n".join(details)
	)

	var next_level: LevelData = (
		_get_next_level()
	)

	next_level_button.visible = (
		objective_result.passed
		and next_level != null
	)

	retry_button.visible = true
	result_back_button.visible = true

	result_overlay.visible = true

	if next_level_button.visible:
		next_level_button.grab_focus()
	else:
		retry_button.grab_focus()


func _get_next_level() -> LevelData:
	if level_data == null:
		return null

	if String(level_data.id) == "level_01":
		return LEVEL_02

	return null


func _on_next_level_pressed() -> void:
	var next_level: LevelData = (
		_get_next_level()
	)

	if next_level == null:
		return

	print(
		"NEXT LEVEL PRESSED: ",
		next_level.id
	)

	GameSession.select_level(
		next_level
	)

	var error: Error = (
		get_tree().change_scene_to_file(
			GAMEPLAY_SCENE_PATH
		)
	)

	if error != OK:
		push_error(
			"GameplayController: failed to open next level. Error: "
			+ str(error)
		)


func _on_retry_pressed() -> void:
	print("RETRY LEVEL PRESSED")

	GameSession.select_level(
		level_data
	)

	var error: Error = (
		get_tree().reload_current_scene()
	)

	if error != OK:
		push_error(
			"GameplayController: failed to reload level. Error: "
			+ str(error)
		)


func _on_result_back_pressed() -> void:
	print("RESULT BACK TO LEVELS PRESSED")

	GameSession.clear_selected_level()

	var error: Error = (
		get_tree().change_scene_to_file(
			LEVEL_SELECT_SCENE_PATH
		)
	)

	if error != OK:
		push_error(
			"GameplayController: failed to open level select. Error: "
			+ str(error)
		)


func _count_filled_seats(
	placements: Array[CreatureData]
) -> int:
	var filled_seats: int = 0

	for creature: CreatureData in placements:
		if creature != null:
			filled_seats += 1

	return filled_seats


func _format_display_name(
	raw_name: String
) -> String:
	return (
		raw_name
		.replace("_", " ")
		.capitalize()
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
