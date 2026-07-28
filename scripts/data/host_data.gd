class_name HostData
extends Resource


enum ObjectiveType {
	HARMONY,
	DISCORD,
	NATURE
}


@export_category("Identity")

@export var id: StringName = &""


@export_category("Localization")

@export var name_key: StringName = &""
@export var description_key: StringName = &""


@export_category("Objective")

@export var objective_type: ObjectiveType = ObjectiveType.HARMONY


@export_category("Visuals")

@export var portrait: Texture2D
