class_name CollisionScript

extends PlayerScript

@onready var pauseMenu = $"LeftHand/#UI/pause_menu"
@onready var debugMenu = $"LeftHand/#UI/debug_menu"
# we take the instantiated debug menu UI scene
@onready var debugMenu_scene = debugMenu.get_scene_instance() 
@onready var FunctionPointer = $"RightHand/#XR_PLUGIN/FunctionPointer"
@onready var sfx_footsteps = $"sfx_footsteps"  
@onready var musicbg = $musicbg


var previous_position: Vector3

signal hit_by_ennemy(damage)



# test values, rememmber to remove !!!
var counter = 0
var btn_presed
var incr = 0




func _ready() -> void:
	super._ready()
	musicbg.volume_db = -30
	musicbg.play()
	previous_position = global_transform.origin
	
func _process(delta: float) -> void:
	counter += 1
	# print(debugMenu_scene.get_content())
	debugMenu_scene.update_content(['some test values', get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed, counter, btn_presed, incr])
	recharge_mana()
	if(!musicbg.playing):
		musicbg.play()
	
	# Gestion du son des pas
	var movement_speed = global_transform.origin - previous_position
	previous_position = global_transform.origin  # Met à jour la position précédente

	#if movement_speed.length() > 0.1:  # Ajuste ce seuil selon la sensibilité
		#if sfx_footsteps.playing == false:
			#sfx_footsteps.play()
	#else:
		#sfx_footsteps.stop()

## Function which regen the the number of manapoint every second (replace this function later)


func _on_area_3d_body_entered(body):
 #	print("Collision détectée avec :", body.name)
	if body.is_in_group("PoisonBall"): # DO NOT REMOVE
		hp -= body.damage




func button_main_hand_pressed(name):
	if name == "ax_button":
		var scene = get_parent_node_3d().get_node("Spell")
		var selected_spell = which_spell()
		if selected_spell != "":
			var spell_scene = load(selected_spell).instantiate()
			scene.add_child(spell_scene)

func button_main_hand_released(name):
	if(name == "ax_button"):
		var scene = get_parent_node_3d().get_node("Spell")
		if scene:
			for spell in scene.get_children():
				spell.mode = 1

func button_other_hand_pressed(name):
	btn_presed = name
	if name == 'by_button':
		incr += 1
	if name == 'ax_button':
		incr -= 1
		# create the menu for spell selection when the button is pressed
		var spell_menu = load("res://UI/Scenes/SpellMenu.tscn")
		var player_scene = get_tree().current_scene.get_node("Player")
		player_scene.add_child(spell_menu.instantiate())

func button_other_hand_released(name):
	if name == 'ax_button':
		# destroy the menu for spell selection when the button is released
		var spell_menu_scene = get_tree().current_scene.get_node("Player/SpellMenu")
		if spell_menu_scene:
			spell_menu_scene.destroy()





# function to reload to game when the B button is pressed
# no more needed thanks to the left hand menu
func _on_right_hand_button_pressed(name):
	if main_hand == Hands.RIGHT:
		button_main_hand_pressed(name)
	else:
		button_other_hand_pressed(name)


func _on_right_hand_button_released(name):
	if main_hand == Hands.RIGHT:
		button_main_hand_released(name)
	else:
		button_other_hand_released(name)


func _on_left_hand_button_pressed(name):
	btn_presed = name
	if name == "by_button":
		debugMenu.visible = !debugMenu.visible
	if name == "menu_button":
		Global.exit_menu()
		get_tree().paused = !get_tree().paused
		pauseMenu.visible = !pauseMenu.visible
		FunctionPointer.visible = !FunctionPointer.visible
		
	
	if main_hand == Hands.LEFT:
		button_main_hand_pressed(name)
	else:
		button_other_hand_pressed(name)

func _on_left_hand_button_released(name: String) -> void:
	if main_hand == Hands.LEFT:
		button_main_hand_released(name)
	else:
		button_other_hand_released(name)
