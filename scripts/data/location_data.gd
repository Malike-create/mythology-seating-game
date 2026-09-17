class_name LocationData
extends Resource


@export_category("Identity")

@export var id: StringName = &""


@export_category("Localization")

@export var name_key: StringName = &""
@export var description_key: StringName = &""


@export_category("Visuals")

@export var background: Texture2D
@export var icon: Texture2D


@export_category("Audio")

@export var music: AudioStream
