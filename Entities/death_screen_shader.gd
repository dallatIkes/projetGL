# Get the death screen shader node as "this"
this = $"XRCamera3D/DeathScreenShader"

@onready var player = get_tree().current_scene.get_node("Player")

var current_hp : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = player.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_hp = player.hp
	if current_hp < 0:
		this.visible = true
