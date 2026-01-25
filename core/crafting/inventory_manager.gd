class_name InventoryManager
extends Control

var Items: Array[Item] = []
var Slots: Array[InventorySlot] = []
@export var max_stack: int = 20

func _ready() -> void:
	for child in $MarginContainer/InventoryRow1.get_children():
		if child is InventorySlot:
			child.InventoryManagerInstance = self
			Slots.append(child)

# MAIN METHODS

func store_item(item: Item, count: int) -> void:
	var slot = get_item_stack_for_storing(item)
	
	if slot != null:
		slot.add_to_stack(count)
		return

	slot = get_free_slot()
	if slot == null:
		return

	slot.set_item(item, count)


func less_item(item: Item, count: int):
	var slot = get_item_stack_for_removing(item)	

	if slot == null:
		print("No item stack found for " + item.item_name)
		return

	if count > slot.item_count:
		print("Not enough items")
		return

	slot.sub_from_stack(count)
	return true

# Coroutines

func get_free_slot() -> InventorySlot:
	for slot in Slots:
		if slot.is_empty:
			return slot
	return null


func get_item_stack_for_storing(item: Item) -> InventorySlot:
	for slot in Slots:
		if slot.is_empty:
			continue
		if slot.item.item_name == item.item_name:
			if slot.item_count != max_stack:
				return slot
	return null


func get_item_stack_for_removing(item: Item) -> InventorySlot:
	for slot in Slots:
		if slot.is_empty:
			continue
		if slot.item.item_name == item.item_name:
			return slot
	return null


# DEBUG

func _on_button_pressed() -> void:
	# note to future devs: use UID instead of string path, from Constants autoload script
	var item_resource: Item = load("res://resources/items/materials/sample_item_1.tres")
	print("storing item")
	store_item(item_resource, 10)


func _on_button_2_pressed() -> void:
	# note to future devs: use UID instead of string path, from Constants autoload script
	var item_resource: Item = load("res://resources/items/materials/sample_item_1.tres")
	print("removing item")
	less_item(item_resource, 10)
