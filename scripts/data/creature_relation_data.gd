class_name CreatureRelationData
extends Resource


enum Attitude {
	NEUTRAL,
	LIKE,
	DISLIKE,
	TOLERATE
}


## ID другого существа.
## Например: "alpakarakush".
@export var target_creature_id: StringName = &""


## Тип отношения к этому существу.
@export var attitude: Attitude = Attitude.NEUTRAL


## Числовой модификатор отношения.
##
## LIKE обычно +1.
## DISLIKE обычно -2.
## NEUTRAL обычно 0.
## TOLERATE обычно 0.
@export var modifier: int = 0
