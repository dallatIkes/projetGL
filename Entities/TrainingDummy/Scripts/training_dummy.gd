extends Node

var last_damage : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_damage = 0
	add_to_group("Creature") # DO NOT REMOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$DamageLabel.text = "Damage : "
	$DamageLabel.text += str(last_damage)


func take_damage(damages : int):
	last_damage = damages
	
