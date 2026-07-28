class_name CreatureData
extends Resource


enum Category {
	GOOD,
	NEUTRAL,
	EVIL
}


@export_category("Identity")

## Постоянный внутренний ID.
## Никогда не переводится.
##
## Например:
## umai_ene
## alpakarakush
## azhydaar
@export var id: StringName = &""


## Доброе, нейтральное или злое существо.
@export var category: Category = Category.NEUTRAL


@export_category("Localization")

## Ключи текста.
## Сам русский/кыргызский текст здесь хранить не будем.
@export var name_key: StringName = &""
@export var role_key: StringName = &""
@export var description_key: StringName = &""


@export_category("Relationships")

## Индивидуальные отношения к другим существам.
@export var relationships: Array[CreatureRelationData] = []


@export_category("Ability")

## Уникальная способность существа.
@export var ability: AbilityData


@export_category("Visuals")

## Небольшой портрет для карточек и UI.
@export var portrait: Texture2D

## Полная иллюстрация персонажа.
@export var full_art: Texture2D
