extends Node

var f : FileAccess


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_settings_file()
	load_settings()
	


func save_settings():
	var settings = get_settings()

	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(settings))
	file.close()


func load_settings():
	if not FileAccess.file_exists("user://settings.json"):
		return {}  # Default settings if file doesn't exist

	var file = FileAccess.open("user://settings.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var settings = JSON.parse_string(content)
	
	set_settings(settings)
	

func init_settings_file():
	var path = "user://settings.json"

	if FileAccess.file_exists(path):
		return  # File already exists, do nothing

	var default_settings = get_settings()

	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(default_settings))
		file.close()
		print("Settings file created with default values.")
	else:
		push_error("Failed to create settings file.")



func get_settings() -> Dictionary:	
	var player_scene : PlayerScript = get_tree().current_scene.get_node("Player")
	var settings = {}
	
	settings["CameraAngleRotation"] = Global.angle
	settings["PlayerSpeed"] = player_scene.get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed
	settings["MainHand"] = player_scene.main_hand
	
	return settings

func set_settings(settings: Dictionary):
	var player_scene : PlayerScript = get_tree().current_scene.get_node("Player")

	if settings.has("CameraAngleRotation"):
		Global.angle = settings["CameraAngleRotation"]

	if settings.has("PlayerSpeed"):
		player_scene.get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed = settings["PlayerSpeed"]

	if settings.has("MainHand"):
		player_scene.main_hand = settings["MainHand"]
