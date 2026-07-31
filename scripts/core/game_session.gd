extends Node


## Уровень, который игрок выбрал
## на экране выбора уровней.
var selected_level: LevelData = null


func _ready() -> void:
	print("GAME SESSION READY")


## Запоминает выбранный уровень.
func select_level(level: LevelData) -> void:
	selected_level = level

	if selected_level == null:
		print("Selected level cleared.")
		return

	print("Selected level: ", selected_level.id)


## Очищает выбранный уровень.
func clear_selected_level() -> void:
	selected_level = null


## Проверяет, выбран ли сейчас уровень.
func has_selected_level() -> bool:
	return selected_level != null
