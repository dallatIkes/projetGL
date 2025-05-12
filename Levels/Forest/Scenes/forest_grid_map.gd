extends Node3D


#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.should_restore_position:
		var player = get_node("Player/PlayerBody")
		if player:
			# Restaurer la position du joueur à partir de GameState
			player.global_transform.origin = GameState.player_position
			GameState.should_restore_position = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
