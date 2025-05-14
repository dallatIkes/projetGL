extends Node

signal new_angle_value(angle)
@onready var sfx1 = $"sfx1"
@onready var sfx2 = $"sfx2"

@onready var player_scene = get_tree().current_scene.get_node("Player")
@onready var node_hand = player_scene.get_node("LeftHand/#XR_PLUGIN/MovementDirect")

func _ready():
	$HSlider.value = Global.angle;
	node_hand.max_speed = 5  # Define the default hand speed
	change_text_button_main_hand()

	$HSliderPlayerSpeed.value = node_hand.max_speed
	$LabelPlayerSpeed.text = str(node_hand.max_speed)
	
func _on_h_slider_drag_ended(value_changed):
	playSfx()
	Global.angle = $HSlider.value;
	$Label2.text = str($HSlider.value)

func _on_return_button_pressed():
	playSfx()
	$".".visible = false;
	$"../VBoxContainer".visible = true;


func _on_check_box_pressed():
	playSfx()
	$HSlider.editable = !$HSlider.editable
	Global.turnmode_changing()



# checkbox to change main hand
func _on_button_main_hand_pressed() -> void:
	playSfx()
	var player_scene = get_tree().current_scene.get_node("Player")
	if player_scene.main_hand == PlayerScript.Hands.RIGHT:
		player_scene.main_hand = PlayerScript.Hands.LEFT
	else:
		player_scene.main_hand = PlayerScript.Hands.RIGHT
	change_text_button_main_hand()

func change_text_button_main_hand():
	var player_scene = get_tree().current_scene.get_node("Player")
	$ButtonMainHand.text = "Main hand : "
	if player_scene.main_hand == PlayerScript.Hands.LEFT:
		$ButtonMainHand.text += "Left"
	else:
		$ButtonMainHand.text += "Right"




func _on_h_slider_player_speed_drag_ended(value_changed: bool) -> void:
	playSfx()
	node_hand.max_speed = $HSliderPlayerSpeed.value
	$LabelPlayerSpeed.text = str(node_hand.max_speed)


func _on_button_key_view_pressed() -> void:
	playSfx()
	$".".visible = false;
	$"../VBoxContainerControls".visible = true;

func playSfx():
	randomize()  # Initialise the random number generator
	var result = randi_range(1, 2)  #Generate 1 or 2
	if(result == 1):
		sfx1.play()
	else : 
		sfx2.play()


func _on_hiding_hp_bars_pressed():
	var entities_node = get_tree().get_current_scene().get_node("Entities")
	if entities_node:
		for child in entities_node.get_children():
			if child is Entity:
				if child.has_node("HPBar"):
					var hp_bar = child.get_node("HPBar")
					hp_bar.visible = not hp_bar.visible


func _on_teleport_pressed() -> void:
	player_scene.switch_movement()
	
