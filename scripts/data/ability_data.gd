class_name AbilityData
extends Resource


enum AbilityType {
	NONE,
	ADJACENT_HAPPINESS_BONUS,
	SELF_BONUS_PER_CATEGORY,
	AMPLIFY_POSITIVE_BONUS,
	ADJACENT_CATEGORY_BONUS,
	REDUCE_NEGATIVE_PENALTY,
	IGNORE_ALIGNMENT_PENALTY,
	ADJACENT_CATEGORY_PENALTY
}


enum TargetType {
	SELF,
	NEIGHBORS
}


@export var type: AbilityType = AbilityType.NONE
@export var amount: int = 0
@export var target: TargetType = TargetType.SELF

## -1 означает, что категория для этой способности не используется.
@export var target_category: int = -1
