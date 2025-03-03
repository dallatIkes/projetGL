extends Control

# Scene-Tree Node references
@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType # not shown
@onready var item_description = $DetailsPanel/ItemDescription

# Slot item
var item = null

# Show usage panel for player to use/drop item
# voir pour le bouton qu'il faut associer
func _on_item_button_pressed():
	if item != null && item.type != "armor":
		details_panel.visible = !details_panel.visible

# Default empty slot
func set_empty():
	icon.texture = null
	item_name.text = ""

# Set slot item with its values 
func set_item(item : Item): #not using itemAmount becaus we don't use any collectible
	icon.texture = item.inventory_texture 
	# quantity_label.text = str(item_amount.amount)
	item_name.text = str(item.name)
	item_description.text = str(item.description)
	item_type.text = str(item.type)
	#if item["effect"] != "":
	#	item_effect.text = str("+ ", item["effect"])
	#else: 
	#	item_effect.text = ""


# Unequip = Remove item from equiped objects	
func _on_unequip_button_pressed():
	details_panel.visible = false
	if item != null:
		set_empty()
