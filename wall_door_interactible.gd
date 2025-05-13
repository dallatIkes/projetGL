extends Node3D

enum DoorType{
	MANUAL,
	LEVER,
}

@export var door_type : DoorType = DoorType.MANUAL



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_type == DoorType.MANUAL:
		get_node("wallDoor/door").set("rotation_degrees", Vector3(0, min(max(-atan((get_node("wallDoor/door").position.x - get_node("wallDoor/GrabPoint").position.x)/(get_node("wallDoor/door").position.z - get_node("wallDoor/GrabPoint").position.z)) * 180 / PI, -45),45), 0))
		
		if get_node("wallDoor/door").position.distance_to(get_node("wallDoor/GrabPoint").position) > 2: # Checks if the grabPoint is in an awkward position
			get_node("wallDoor/GrabPoint").drop() # Force release the lever from the hand

# Opens an automated door
func open() -> void:
	if door_type == DoorType.LEVER:
		while(get_node("wallDoor/door").rotation_degrees.y < 120):
			get_node("wallDoor/door").set("rotation_degrees.y", get_node("wallDoor/door").rotation_degrees.y + 3)

# Closes an automated door
func close() -> void:
	if door_type == DoorType.LEVER:
		while(get_node("wallDoor/door").rotation_degrees.y > 0):
			get_node("wallDoor/door").set("rotation_degrees.y", get_node("wallDoor/door").rotation_degrees.y - 3)
