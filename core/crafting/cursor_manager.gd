extends Node

var tooltip_item: Item = null
var show_info: bool = false

var slot_source: InventorySlot = null
var slot_dest: InventorySlot = null

var is_dragging: bool = false
var has_item: bool = false

var buffer_item: Item = null

var state: STATE = STATE.default

enum STATE {
	default,
	dragging,
}

func _process(_delta: float) -> void:
	match state:
		STATE.default:
			if Input.is_action_just_pressed("ui_left_click"):
				if tooltip_item != null:
					is_dragging = true
					GameToolTip.display_description(false)
					GameToolTip.display_texture(true)
					state = STATE.dragging
			if slot_source and slot_dest:
				if slot_source.item == null:
					return
				print("slot_source" + str(slot_source))
				print("slot_dest" + str(slot_dest))
				var temp_item = null
				if slot_source.item != null:
					temp_item = slot_source.item.duplicate()
				var temp_count = slot_source.item_count
				slot_source.set_item(slot_dest.item, slot_dest.item_count)
				slot_dest.set_item(temp_item, temp_count)
				GameToolTip.display_description(true)

			slot_source = null
			slot_dest = null

		STATE.dragging:
			if Input.is_action_just_released("ui_left_click"):
				is_dragging = false
				if buffer_item != null:
					tooltip_item = buffer_item
					buffer_item = null
					GameToolTip.display_description(true)
				else:
					GameToolTip.display_description(false)
				GameToolTip.display_texture(false)
				state = STATE.default


func set_tooltip(item: Item) -> void:
	tooltip_item = item
	GameToolTip.item = item
	GameToolTip.display(true)
	GameToolTip.texture.texture = item.texture
	GameToolTip.label.text = item.info
	GameToolTip.display_description(true)
	GameToolTip.display_texture(false)

func set_buffer_item(item: Item) -> void:
	buffer_item = item

func clear_tooltip() -> void:
	tooltip_item = null
	buffer_item = null
	GameToolTip.item = null
	GameToolTip.display(false)
	GameToolTip.display_description(false)
	GameToolTip.display_texture(false)
