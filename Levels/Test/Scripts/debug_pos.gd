extends MeshInstance3D

#Set this node visible for debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color(0, 1, 0)
	mesh.surface_set_material(0, material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lever_down_position(lever: Variant) -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color(1, 0, 0)
	mesh.surface_set_material(0, material)


func _on_lever_neutral_position(lever: Variant) -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color(0, 1, 0)
	mesh.surface_set_material(0, material)


func _on_lever_up_position(lever: Variant) -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color(0, 0, 1)
	mesh.surface_set_material(0, material)
