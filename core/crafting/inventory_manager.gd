class_name InventoryManager
extends Control

var Items: Array[Item] = []
var Slots: Array[InventorySlot] = []
@export var max_stack: int = 20

var selected_index: int = -1

func _ready() -> void:
	for child in $MarginContainer/InventoryRow1.get_children():
		if child is InventorySlot:
			var slot := child as InventorySlot
			slot.InventoryManagerInstance = self
			Slots.append(slot)

	# Optional: auto-select slot 1 on open
	if Slots.size() > 0:
		select_slot(0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inv_select_1"): select_slot(0)
	elif event.is_action_pressed("inv_select_2"): select_slot(1)
	elif event.is_action_pressed("inv_select_3"): select_slot(2)
	elif event.is_action_pressed("inv_select_4"): select_slot(3)
	elif event.is_action_pressed("inv_select_5"): select_slot(4)
	elif event.is_action_pressed("inv_select_6"): select_slot(5)

func select_slot(index: int) -> void:
	if index < 0 or index >= Slots.size():
		return

	# Unhighlight previous
	if selected_index >= 0 and selected_index < Slots.size():
		Slots[selected_index].set_selected(false)

	selected_index = index
	Slots[selected_index].set_selected(true)

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
	
	if item == null:
		return

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
		if slot.is_empty or slot.item == null or item == null:
			continue
		if slot.item.item_name == item.item_name:
			if slot.item_count != max_stack:
				return slot
	return null


func get_item_stack_for_removing(item: Item) -> InventorySlot:
	for slot in Slots:
		if slot.is_empty or slot.item == null or item == null:
			continue
		if slot.item.item_name == item.item_name:
			return slot
	return null

func get_item_at_slot_index(index: int) -> Item:
	if index < 0 or index >= Slots.size():
		return null

	var slot := Slots[index]
	if slot == null or slot.is_empty or slot.item == null:
		return null

	return slot.item

# DEBUG

func _on_button_pressed() -> void:
	# note to future devs: use UID instead of string path, from Constants autoload script
	var item_resource: Item = load(Constants.ITEMS.bucket)
	print("storing item")
	store_item(item_resource, 10)


func _on_button_2_pressed() -> void:
	# note to future devs: use UID instead of string path, from Constants autoload script
	var item_resource: Item = load(Constants.ITEMS.bucket)
	print("removing item")
	less_item(item_resource, 10)
