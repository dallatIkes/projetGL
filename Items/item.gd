extends Resource
class_name Item

@export var item_name : String = ""
@export var description : String = ""
@export var type : String = ""
@export var inventory_texture : Texture2D = null

func _init(item_name : String = "", description : String = "", type : String = "", inventory_texture : Texture2D = null) -> void:
	self.item_name = item_name
	self.description = description
	self.type = type
	self.inventory_texture = inventory_texture

func set_item_name(new_name : String) -> void:
	self.item_name = new_name
func set_description(new_desc : String) -> void:
	self.description = new_desc
func set_type(new_type : String) -> void:
	self.type = new_type
func set_inv_text(new_texture : Texture2D) -> void:
	self.inventory_texture = new_texture
