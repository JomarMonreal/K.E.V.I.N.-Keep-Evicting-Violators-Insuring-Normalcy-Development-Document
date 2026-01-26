class_name InventorySlot
extends PanelContainer

var InventoryManagerInstance: InventoryManager = null
var item: Item = null

var is_mouse_inside: bool = false
var item_count: int = 0
var is_empty: bool = true
var is_selected: bool = false

@onready var ItemTexture = $MarginContainer/VBoxContainer/TextureRect
@onready var ItemCount = $MarginContainer/VBoxContainer/TextureRect/TextEdit

func _ready() -> void:
	clear_item()
	_apply_border(false)

func set_selected(selected: bool) -> void:
	is_selected = selected
	_apply_border(selected)

func _apply_border(selected: bool) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0.5) # transparent background
	sb.border_width_left = 2
	sb.border_width_top = 2
	sb.border_width_right = 2
	sb.border_width_bottom = 2

	# “Bordered when selected”
	sb.border_color = Color(1, 1, 1, 1) if selected else Color(0, 0, 0, 0)

	add_theme_stylebox_override("panel", sb)


func _process(_delta: float) -> void:
	if is_mouse_inside:
		if Input.is_action_just_pressed("ui_left_click"):
			CursorManager.slot_source = self
		if Input.is_action_just_released("ui_left_click"):
			CursorManager.slot_dest = self


func set_item(new_item: Item, count) -> void:
	if new_item == null:
		item = null
		item_count = 0
		ItemTexture.texture = null
		ItemCount.text = ""
		is_empty = true
		return
	item = new_item
	print(item.item_name)
	ItemTexture.texture = item.texture
	item_count = count
	if item_count > InventoryManagerInstance.max_stack:
		item_count = InventoryManagerInstance.max_stack
	ItemCount.text = "x" + str(item_count)
	is_empty = false


func add_to_stack(count) -> void:
	item_count += count
	if item_count > InventoryManagerInstance.max_stack:
		item_count = InventoryManagerInstance.max_stack
	ItemCount.text = "x" + str(item_count)


func sub_from_stack(count) -> void:
	item_count -= count
	if item_count == 0:
		clear_item()
		return
		
	ItemCount.text = "x" + str(item_count)


func clear_item() -> void:
	item_count = 0
	item = null
	ItemTexture.texture = null
	ItemCount.text = ""
	is_empty = true


func _on_mouse_exited() -> void:
	is_mouse_inside = false
	if not CursorManager.is_dragging:
		CursorManager.clear_tooltip()

func _on_mouse_entered() -> void:
	is_mouse_inside = true
	if item != null:
		if CursorManager.is_dragging:
			CursorManager.set_buffer_item(item)
			return
		CursorManager.set_tooltip(item)
