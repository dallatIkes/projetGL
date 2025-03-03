
#extends Control

#class_name Inventory

#@onready var isHidden := true 
#@onready var tween := create_tween()
#@onready var panel = $Panel
#@onready var hidden_position = position # (rect_position)
#@onready var visible_position = hidden_position - panel.size * Vector2.RIGHT # (rect_size)

#signal hidden_changed(value)

### ACCESSORS ###

#func set_hidden(value: bool) -> void:
#	if value != isHidden:
#		isHidden = value
#		emit_signal("hidden_changed", hidden)
#func is_hidden() -> bool: return isHidden

### BUILT-IN ###

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var __ = connect("hidden_changed", self, "_on_hidden_changed")
#	pass # Replace with function body.

### LOGIC ###

# function handling apparition and disparition of the inventory when the key is pressed
#func _animation(appear: bool) -> void:
#	var from = position #hidden_position
#	var to = visible_position if appear else hidden_position
#	tween.interpolate_property(self, "rect_position:x", from, to, 1, tween.TRANS_CUBIC) # can change the TRANS
#	tween.start() 
