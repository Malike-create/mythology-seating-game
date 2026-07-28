class_name HostObjectiveResult
extends RefCounted


var passed: bool = false

var all_seats_filled: bool = false
var happiness_met: bool = false
var conflicts_met: bool = false

var total_happiness: int = 0
var critical_conflicts: int = 0


func get_status_text() -> String:
	if passed:
		return "LEVEL COMPLETE!"

	if not all_seats_filled:
		return "PLACE ALL CREATURES"

	if not happiness_met and not conflicts_met:
		return "MORE HAPPINESS / TOO MANY CONFLICTS"

	if not happiness_met:
		return "NOT ENOUGH HAPPINESS"

	if not conflicts_met:
		return "TOO MANY CRITICAL CONFLICTS"

	return "OBJECTIVE NOT MET"
