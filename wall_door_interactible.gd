extends Node3D

enum DoorType{
	MANUAL,
	OPEN,
	CLOSED,
}

@export var door_type : DoorType = DoorType.MANUAL



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_type == DoorType.MANUAL:
		get_node("wallDoor/door").set("rotation_degrees", Vector3(0, min(max(atan((get_node("wallDoor/door").position.z - get_node("wallDoor/GrabPoint").position.z)/(get_node("wallDoor/door").position.x - get_node("wallDoor/GrabPoint").position.x)) * 180 / PI, -160),160), 0))
		
		if get_node("wallDoor/door").position.distance_to(get_node("wallDoor/GrabPoint").position) > 2: # Checks if the grabPoint is in an awkward position
			get_node("wallDoor/GrabPoint").drop() # Force release the lever from the hand
	
	if door_type == DoorType.OPEN and get_node("wallDoor/door").rotation_degrees.y < 120:
		get_node("wallDoor/door").set("rotation_degrees.y", get_node("wallDoor/door").rotation_degrees.y + 3)

# Closes an automated door
	if door_type == DoorType.CLOSED and get_node("wallDoor/door").rotation_degrees.y > 0:
		get_node("wallDoor/door").set("rotation_degrees.y", get_node("wallDoor/door").rotation_degrees.y - 3)

# Sets an automated door to open
func open() -> void:
	if door_type == DoorType.CLOSED:
		door_type = DoorType.OPEN

# Sets an automated door to close
func close() -> void:
	if door_type == DoorType.OPEN:
		door_type = DoorType.CLOSED


func snapDoor() -> void:
	var curPos = get_node("wallDoor/GrabPoint").position
	get_node("GrabPoint").set("position", curPos * 0.4 / curPos.distance_to(Vector3(0,0,0)))

func _on_grab_point_dropped(pickable: Variant) -> void:
	snapDoor()
