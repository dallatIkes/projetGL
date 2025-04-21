class_name Tuto

extends Creature

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	var hp_bar_instance = preload("res://UI/Scenes/HPBar.tscn").instantiate()
	hp_bar_instance.entity_scene = self  # Lier la bonne entité
	add_child(hp_bar_instance)  # Ajouter la barre au mob
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
