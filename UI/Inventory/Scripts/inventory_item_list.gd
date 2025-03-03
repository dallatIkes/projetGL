
extends ItemList
class_name InventoryItemList


@onready var equip_popup: PopupPanel = $EquipPopup
@onready var equip_button: Button = $EquipPopup/VBoxContainer/EquipButton
@onready var equip_label: Label = $EquipPopup/VBoxContainer/Label

var selected_item: ItemAmount = null
#var selected_item_id = -1 

#signal selected_item_id_changed(id)

### ACCESSORS ###

#func set_selected_item_id(value: int) -> void:
#	if value == -1 :
#		selected_item_id = value
#	else :
#		selected_item_id = wrapi(value, 0, get_item_count()) # wrap is a modulo function
#	emit_signal("selected_item_id_changed")

#func get_selected_item_id() -> int:
#	return selected_item_id

### BUILT-IN ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	connect("selected_item_id_changed",_on_selected_item_id_changed)
	connect("item_selected", _on_item_selected)
	equip_button.connect("pressed", _on_equip_pressed)
	testItemList()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

### DEBUG & TEST ##

# Test function
func testItemList() -> void:
	var testItem : Item = Item.new()
	testItem.name = "un item"
	var testItemAmount : ItemAmount = ItemAmount.new(testItem, 1)
	update_item_display(testItemAmount)
	var testItem2 : Item = Item.new()
	testItem2.name = "un autre item"
	var testItemAmount2 : ItemAmount = ItemAmount.new(testItem2, 1)
	update_item_display(testItemAmount2)
	var testItem3 : Item = Item.new()
	testItem3.name = "item3"
	var testItemAmount3 : ItemAmount = ItemAmount.new(testItem3, 2)
	update_item_display(testItemAmount3)

### LOGIC ###

func update_item_display(item_amount: ItemAmount) -> void:
	# search item place in inventory (-1 if not found) 
	var item_id = _find_item_in_list(item_amount)
	#var item_id = _find_item_in_list(item_amount.item)
	# create the text to display in inventory
	var item_text = "%s : %d" % [item_amount.item.name, item_amount.amount]
	
	# if item not on the list, display it in another inventory line
	if item_id == -1:
		add_item(item_text) #add_item(item_text, item_amount.item.inventory_texture)
		item_id = get_item_count() - 1
		set_item_metadata(item_id, item_amount)
	
	else :
		if item_amount.amount <= 0:
			remove_item(item_id)
		else : 
			set_item_text(item_id,item_text)

# Search the item in the list
func _find_item_in_list(item_amount: ItemAmount) -> int:
#func _find_item_in_list(item: Item) -> int:
	for i in range (get_item_count()):
		if item_amount == get_item_metadata(i):
		#if item.name == get_item_metadata(i).item.name:
			return i
	return -1

# Select another item
#func _update_selected_item() -> void:
#	if selected_item_id == -1:
#		deselect_all() 
#	select(selected_item_id)

func _on_item_selected(index: int) -> void:
	selected_item = get_item_metadata(index)
	if selected_item:
		equip_label.text = "Do you want to equip " + selected_item.item.name + " ?"
		equip_popup.popup_centered()

### INPUTS ###

func _on_equip_pressed():
	if selected_item:
		print("Objet équipé :", selected_item.item.name)
		equip_popup.hide()

### SIGNALS ###

func _on_inventory_data_manager_item_added(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)

func _on_inventory_data_manager_item_removed(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)

#func _on_selected_item_id_changed(id: int) -> void:
#	pass

# If we have no collectible object, every ItemAmount can be changed for Item
