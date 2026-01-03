class_name CraftingRecipe
extends Resource

@export var ingredients: Array[CraftingIngredient]
@export var output: CraftingIngredient

func craft() -> void:
	pass

func can_craft() -> void:
	pass
