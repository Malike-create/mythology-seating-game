class_name LevelData
extends Resource


@export_category("Identity")

@export var id: StringName = &""
@export var title_key: StringName = &""


@export_category("Level Setup")

@export var host: HostData

@export var creatures: Array[CreatureData] = []

@export_range(1, 12, 1)
var seat_count: int = 4

@export var wrap_around: bool = false


@export_category("Win Conditions")

## Минимальное суммарное счастье.
@export var required_happiness: int = 0

## Максимально допустимое количество
## критических соседств.
@export var max_critical_conflicts: int = 0
