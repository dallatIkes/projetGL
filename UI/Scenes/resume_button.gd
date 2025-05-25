extends Button
@onready var sfx_1 = $"sfx_1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	sfx_1.play()


func _on_movement_pressed() -> void:
	pass # Replace with function body.
