extends Node3D

const WORLD = preload("res://Levels/Forest/Scenes/forest_grid_map.tscn")
@onready var sfx_cave = $sfx_cave
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#We start the music
	sfx_cave.volume_db = -20
	sfx_cave.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_torch_torch_lit(torch: Variant) -> void:
	# When the torh is on fireeeee, the player can return in the forrest scene
	get_tree().change_scene_to_packed(WORLD) # Start and launch the appropiate scene. 
