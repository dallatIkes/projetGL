extends Control

# Scene-Tree Node references
@onready var icon = $InnerBorder/ItemIcon
#@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/MarginContainer/VBoxContainer/ItemName
@onready var item_type = $DetailsPanel/MarginContainer/VBoxContainer/ItemType #not shown
@onready var item_description = $DetailsPanel/MarginContainer/VBoxContainer/ItemDescription
@onready var item_text = $InnerBorder/ItemText

@onready var debug_menu = get_node("LeftHand/debug_menu")

# Slot item
var item = null

# Show usage panel for player to use/drop item
# voir pour le bouton qu'il faut associer
func _on_item_button_pressed() -> void:
	if item != null && item.type != "armor":
		details_panel.visible = !details_panel.visible

# Default empty slot
func set_empty() -> void:
	icon.texture = null
	item_name.text = ""

# Set slot item with its values 
func set_item(item : Item) -> void: #not using itemAmount because we don't use any collectible
	if item != null : 
		item_name.text = item.item_name
		item_text.text = item_name.text
		icon.texture = item.inventory_texture 
		# quantity_label.text = str(item_amount.amount)
	
		item_description.text = item.description
		item_type.text = item.type
		#if item["effect"] != "":
		#	item_effect.text = str("+ ", item["effect"])
		#else: 
		#	item_effect.text = ""
	else :
		item_text.text = "null"


# Unequip = Remove item from equiped objects	
func _on_unequip_button_pressed() -> void:
	details_panel.visible = false
	if item != null:
		set_empty()

func test() -> void:
	var test_item : Item
	test_item = Item.new("test_item", "ptite descri", "test", null)
	item_text.visible = true
	
	# fonctionne jusqu'ici
	
	#debug_menu.update_content(["before entering set_item()",test_item.description,test_item.item_name,test_item.type,test_item.inventory_texture,item_text.visible])
	item_text.text = "before entering set_item()"
	set_item(test_item) # fonctionne pas
	#debug_menu.update_content(["after quiting set_item()",test_item.description,item_description.text,test_item.name,item_name.text,test_item.type,item_type.text,test_item.inventory_texture,item_text.visible])
	
func _ready() -> void:
	await get_tree().process_frame
	test()
