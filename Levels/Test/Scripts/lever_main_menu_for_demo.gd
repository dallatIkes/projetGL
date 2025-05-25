extends Node3D

# Signal emitted when the lever is straight
signal neutral_position(lever)

# Signal emitted when the lever points up
signal up_position(lever)

# Signal emitted when the lever points down
signal down_position(lever)

# Possible positions of the lever
enum LeverPosition{
	NEUTRAL,
	UP,
	DOWN,
}

@export var lever_position : LeverPosition = LeverPosition.NEUTRAL
const WORLD = preload("res://Levels/Forest/Scenes/forest_zone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snapLever()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("LeverStick").set("rotation_degrees", Vector3(0, 0, min(max(-atan((get_node("LeverStick").position.x - get_node("GrabPoint").position.x)/(get_node("LeverStick").position.y - get_node("GrabPoint").position.y)) * 180 / PI, -45),45)))
	
	if get_node("GrabPoint").position.y < 0 or get_node("LeverStick").position.distance_to(get_node("GrabPoint").position) > 1.4 or abs(get_node("GrabPoint").position.z) > 0.3: # Checks if the grabPoint is in an awkward position
		get_node("GrabPoint").drop() # Force release the lever from the hand
	
	if get_node("LeverStick").rotation_degrees.z > 25 and lever_position != LeverPosition.UP:
		lever_position = LeverPosition.UP
		emit_signal("up_position", self)
	elif get_node("LeverStick").rotation_degrees.z < -25 and lever_position != LeverPosition.DOWN:
		lever_position = LeverPosition.DOWN
		emit_signal("down_position", self)
	elif get_node("LeverStick").rotation_degrees.z > -25 and get_node("LeverStick").rotation_degrees.z < 25 and lever_position != LeverPosition.NEUTRAL:
		lever_position = LeverPosition.NEUTRAL
		emit_signal("neutral_position", self)

# Snaps the lever to the correct position
func snapLever() -> void:
	match lever_position:
		LeverPosition.UP:
			get_node("LeverStick").set("rotation_degrees", Vector3(0, 0, -45))
			get_node("GrabPoint").set("position", Vector3(-0.7, 0.7, 0))
			get_tree().quit() # Quit the game if the lever is down
		LeverPosition.DOWN:
			get_node("LeverStick").set("rotation_degrees", Vector3(0, 0, 45))
			get_node("GrabPoint").set("position", Vector3(0.7, 0.7, 0))
			get_tree().change_scene_to_packed(WORLD) # Start and launch the appropiate scene when the lever is up. 
		LeverPosition.NEUTRAL:
			get_node("LeverStick").set("rotation_degrees", Vector3(0, 0, 0))
			get_node("GrabPoint").set("position", Vector3(0, 1, 0))

# Called when the player releases the lever
func _on_grab_point_dropped(pickable: Variant) -> void:
	snapLever()
