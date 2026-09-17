class_name LevelData
extends Resource


@export_category("Identity")

@export var id: StringName = &""
@export var title_key: StringName = &""


@export_category("Level Setup")

## Локация, в которой проходит уровень.
@export var location: LocationData

## Хозяин уровня и его тип задачи.
@export var host: HostData

## Существа, доступные на уровне.
@export var creatures: Array[CreatureData] = []

@export_range(1, 12, 1)
var seat_count: int = 4

## Если включено, первое и последнее места
## считаются соседними.
@export var wrap_around: bool = false


@export_category("Harmony Win Conditions")

## Минимальное суммарное счастье.
@export var required_happiness: int = 0

## Максимально допустимое количество
## критических соседств.
@export var max_critical_conflicts: int = 0


@export_category("Discord Win Conditions")

## Максимально допустимое суммарное счастье
## для цели Discord.
@export var maximum_happiness: int = 0

## Минимальное количество критических соседств
## для цели Discord.
@export var minimum_critical_conflicts: int = 0
