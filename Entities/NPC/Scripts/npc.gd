class_name NPC

extends Entity

@onready var dialogBox = $"3D_dialogBox"
@onready var dialogBox_scene = dialogBox.get_scene_instance()
@onready var sfx_animal_crossing = $"sfx_animal_crossing"
#@onready var sfx2 = $"sfx2"
var isSpeaking = false
@export_multiline var defaultText = "Hello there! I am a basic Non Player Character (NPC), my duty is not determined yet but I am happy to speak with you :)"

# Say if the npc is interacting with the player
func onInteraction() -> bool:
	pass
	return false

# Return the dialog of the npc, depending on where the player is in the conversation
func dialog() -> void:
	dialogBox_scene.writeText(defaultText)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_to_group("PNJ") # DO NOT REMOVE
	var animation_player = get_node_or_null("AnimationPlayer")
	if animation_player:
		animation_player.play("Take 001")
	#self.dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = get_parent_node_3d().get_parent_node_3d().get_node("Player").global_position
	var dist_player = Movement.distanceVect(position, player_position)
	sfx_animal_crossing.volume_db = -20
	if dist_player <= 5:
		if not isSpeaking:
			if(sfx_animal_crossing.playing == false):
				sfx_animal_crossing.play()
			isSpeaking = true
			dialogBox_scene.visible = true
			self.dialog()  # Trigger the text animation only once
	else:
		sfx_animal_crossing.stop()
		isSpeaking = false
		dialogBox_scene.visible = false


# Called when an area 3D enters this creature's area 3D
func _on_area_3d_area_entered(area: Area3D) -> void:
	if !isInvincible:
		var node_weapon = area.get_parent()
		# hp -= node_weapon.damages
		hp -= 3
		if (hp <= 0):
			queue_free()
