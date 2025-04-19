extends Node3D

@onready var camera_pivot = $camera_pivot
var rotation_speed = 10 
@onready var sfx_menu = $sfx_menu


func _ready():
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		get_viewport().use_xr = true	
	sfx_menu.volume_db = -20  
	sfx_menu.play()
