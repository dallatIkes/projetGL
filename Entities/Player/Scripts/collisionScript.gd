class_name CollisionScript

extends PlayerScript

@onready var pauseMenu = $"LeftHand/#UI/pause_menu"
@onready var debugMenu = $"LeftHand/#UI/debug_menu"
# we take the instantiated debug menu UI scene
@onready var debugMenu_scene = debugMenu.get_scene_instance() 
@onready var FunctionPointer = $"RightHand/#XR_PLUGIN/FunctionPointer"



signal hit_by_ennemy(damage)


# test values, rememmber to remove !!!
var counter = 0
var btn_presed
var incr = 0



func _ready() -> void:
	super._ready()
	var areaSpellMenu = get_node("RightHand/#UI/AreaSpellMenu/MeshInstance3D")
	areaSpellMenu.visible = false
	
	
func _process(delta: float) -> void:
	counter += 1
	# print(debugMenu_scene.get_content())
	debugMenu_scene.update_content(['some test values', get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed, counter, btn_presed, incr])
	recharge_mana()

func _on_area_3d_body_entered(body):
	print("Collision détectée avec :", body.name)

	if (body.name == "Creature"):
		emit_signal("hit_by_ennemy", body.damage)

# function to reload to game when the B button is pressed
# no more needed thanks to the left hand menu

func _on_right_hand_button_pressed(name):
	btn_presed = name
	if name == 'by_button':
		incr += 1
		# get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed += 5
	if name == 'ax_button':
		incr -= 1
		# get_node("LeftHand/#XR_PLUGIN/MovementDirect").max_speed -= 5
		# create the menu for spell selection when the button is pressed
		var spell_menu = load("res://UI/Scenes/SpellMenu.tscn")
		var player_scene = get_tree().current_scene.get_node("Player")
		player_scene.add_child(spell_menu.instantiate())
		
func _on_right_hand_button_released(name):
	if name == 'ax_button':
		# destroy the menu for spell selection when the button is released
		var spell_menu_scene = get_tree().current_scene.get_node("Player/SpellMenu")
		spell_menu_scene.destroy()
		spell_menu_scene.queue_free()



func _on_left_hand_button_pressed(name):
	btn_presed = name
	if name == "by_button":
		debugMenu.visible = !debugMenu.visible
	if name == "ax_button":
		var scene = get_parent_node_3d().get_node("Spell")
		var spell_scene = load(which_spell()).instantiate()
		scene.add_child(spell_scene)
		
	if name == "menu_button":
		Global.exit_menu()
		get_tree().paused = !get_tree().paused
		pauseMenu.visible = !pauseMenu.visible
		FunctionPointer.visible = !FunctionPointer.visible

func _on_left_hand_button_released(name: String) -> void:
	if(name == "ax_button"):
		var scene = get_parent_node_3d().get_node("Spell")
		for bole in scene.get_children():
			bole.mode = 1
