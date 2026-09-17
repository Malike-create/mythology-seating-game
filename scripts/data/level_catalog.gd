class_name LevelCatalog
extends Resource


@export_category("Levels")

@export var levels: Array[LevelData] = []


func get_level_by_index(index: int) -> LevelData:
	if index < 0:
		return null

	if index >= levels.size():
		return null

	return levels[index]


func get_level_by_id(level_id: StringName) -> LevelData:
	for level: LevelData in levels:
		if level == null:
			continue

		if level.id == level_id:
			return level

	return null


func get_next_level(
	current_level: LevelData
) -> LevelData:
	if current_level == null:
		return null

	for index: int in range(levels.size()):
		var level: LevelData = levels[index]

		if level == null:
			continue

		if level.id != current_level.id:
			continue

		var next_index: int = index + 1

		if next_index >= levels.size():
			return null

		return levels[next_index]

	return null


func get_level_count() -> int:
	return levels.size()
