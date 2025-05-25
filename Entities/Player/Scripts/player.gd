extends PlayerScript

@onready var pauseMenu = $"LeftHand/#UI/pause_menu"
@onready var debugMenu = $"LeftHand/#UI/debug_menu"
# we take the instantiated debug menu UI scene
@onready var debugMenu_scene = debugMenu.get_scene_instance() 
@onready var FunctionPointer = $"RightHand/#XR_PLUGIN/FunctionPointer"
@onready var sfx_footsteps = $"sfx_footsteps"  
@onready var sword_hitbox = $"../NiceSword/Hitbox"
@onready var musicbg = $musicbg
@onready var functionTeleportScene = preload("res://addons/godot-xr-tools/functions/function_teleport.tscn")
@onready var movement_direct = $"LeftHand/#XR_PLUGIN/MovementDirect"

var teleport = false
var function_teleport

var previous_position: Vector3

signal hit_by_ennemy(damage)

var max_speed = 3

# test values, rememmber to remove !!!
var counter = 0
var btn_presed
var incr = 0


func _ready() -> void:
	super._ready()
	if musicbg :
		musicbg.volume_db = -30
		musicbg.play()
	previous_position = global_transform.origin
	
	var hand_logic = $"LeftHand/#XR_PLUGIN"

	function_teleport = functionTeleportScene.instantiate()
	function_teleport.name = "FunctionTeleport"
	hand_logic.add_child(function_teleport)
	
	# Désactiver les deux au départ
	_disable_function(function_teleport)

	# Activer le mode de départ
	_set_mode(teleport)
	
func _process(delta: float) -> void:
	counter += 1
	# print(debugMenu_scene.get_content())
	if sword_hitbox :
		debugMenu_scene.update_content(['some test values', get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed, counter, btn_presed, incr, sword_hitbox.velocity, sword_hitbox.velocity_norm, teleport])
	recharge_mana()
	if musicbg: 
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
		

func switch_movement():
	teleport = !teleport
	_set_mode(teleport)

func _set_mode(is_teleport):
	if is_teleport:
		print(">> Activation du mode TELEPORTATION")
		max_speed = movement_direct.max_speed
		movement_direct.max_speed = 0
		_enable_function(function_teleport)
	else:
		print(">> Activation du mode DIRECT")
		_disable_function(function_teleport)
		movement_direct.max_speed = max_speed


func _enable_function(func_node):
	if func_node:
		func_node.set_process(true)
		func_node.set_physics_process(true)
		func_node.set_process_input(true)
		func_node.visible = true


func _disable_function(func_node):
	if func_node:
		func_node.set_process(false)
		func_node.set_physics_process(false)
		func_node.set_process_input(false)
		func_node.visible = false
		
