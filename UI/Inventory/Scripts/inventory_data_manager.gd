extends Node

class_name InventoryDataManager

var item_list: Array = []

signal item_added(item_amount)
signal item_removed(item_amount)

### BUILT-IN ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var __  = connect("object_collected", _on_EVENTS_object_collected)
	pass

### LOGIC ###

# Adding an item to the inventory (if an item is unequiped or collected)
func _append_item(item: Item, amount: int = 1) -> void:
	# we search if we already have the item in the inventory
	var item_amount_id = _find_item_id(item)
	var item_amount = null
	if (item_amount_id==-1):
		# if we don't have it, we add it to the inventory
		item_amount = ItemAmount.new(item, amount)
		item_list.append(item_amount)
	else : 
		# else, we addition the amount 
		item_amount = item_list[item_amount_id]
		item_amount.amount += amount
	emit_signal("item_added", item_amount)

# Removing an item to the inventory (if an item is equiped)
func _remove_item(item: Item, amount: int = 1) -> void:
	# ve verify the existence of the item
	var item_amount_id = _find_item_id(item)
	if (item_amount_id==-1):
		push_error("Could not remove item " + item.name + " from the list, not found in the inventory")
	else : 
		var item_amount = item_list[item_amount_id]
		item_amount.amount -= amount
		emit_signal("item_removed", item_amount)
		if (item_list[item_amount_id].amount <= 0):
			# if we removed all the stock of this very item, we remove the item
			item_list.remove_at(item_amount_id)

# return the position of the item we want to add to inventory if we already have it
# return -1 if we don't have the item
func _find_item_id(item: Item) -> int:
	for i in range(item_list.size()):
		var item_amount = item_list[i]
		if item_amount.item == item:
			return i
	return -1


### DEBUG ###

func _print_inventory() -> void:
	print("--- INVENTORY CONTENT ---")
	print(" ")
	for item_amount in item_list:
		print(item_amount.item.name+ " : " + String(item_amount.amount))
	print(" ")
	print("-------------------------")

### SIGNALS ###

# function for collectible objects only (in our case : money)
func _on_EVENTS_object_collected(item: Item) -> void:
	_append_item(item)
