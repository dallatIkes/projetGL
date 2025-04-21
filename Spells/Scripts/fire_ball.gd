class_name FireBall

extends Spell

var mode : int # The Fireball is inactive at 0, 1 it is visible and 2 the ball is thrown
var t0 : int # The time when the player released the button
var velocity : Vector3 # The velocity that the fireball have when she quit player's hand
var list_of_position : Array # The list of the five last position that takes fireball before button released
var position_t_moins_1 : Vector3 # the position before the player released the button (before every position in the list)

@onready var sfx_fireball = $sfx_fireball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Fireball")
	mode = 0
	t0 = 0
	list_of_position = []
	
	if !player_scene.lost_mana(manaCost): # if the player don't have enough mana, destroy the spell
		destroy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var main_hand_position = select_hand_player().global_position
	
	# in mode 0, the fireball keep the position of the hand and save the 5 last position it takes
	if mode == 0:
		position = main_hand_position
		list_of_position.append(position - player_scene.global_position)
		if list_of_position.size() > 10:
			position_t_moins_1 = list_of_position.pop_at(0)
	
	# in mode 1, the fireball calculates the velocity she has at the instant t0 and keep it for 3 seconds
	elif mode == 1:
		if t0 == 0:
			t0 = Time.get_ticks_msec()  # Définir t0 une seule fois
			sfx_fireball.play()
		velocity = calcul_velocity(main_hand_position, delta)
		linear_velocity = velocity * 5
		# delete fireball after 3 seconds
		if Time.get_ticks_msec() - t0 > 3000:
			destroy()



## Calculates the velocity of the fireball
func calcul_velocity(positionT, delta):
	# Moyenne glissante sur les dernières positions
	var moyenne_position = moyennnePosition(list_of_position)
	return (moyenne_position - position_t_moins_1) / (delta*list_of_position.size())


## Calculates the average position of the last 5 position before button released
func moyennnePosition(list_of_position):
	var list_of_x : Array = []
	var list_of_y : Array = []
	var list_of_z : Array = []
	#Create lists of x, y and z
	for i in range(list_of_position.size()):
		list_of_x.append(list_of_position[i][0])
		list_of_y.append(list_of_position[i][1])
		list_of_z.append(list_of_position[i][2])
		#Calculous of the sums
	var somme_x = 0
	for x in list_of_x:
		somme_x += x
	
	var somme_y = 0
	for y in list_of_y:
		somme_y += y
	
	var somme_z = 0
	for z in list_of_z:
		somme_z += z
	
	# Calculous of the means
	var moyenne_x = somme_x / list_of_x.size()
	var moyenne_y = somme_y / list_of_y.size()
	var moyenne_z = somme_z / list_of_z.size()
	
	# Insert it into a vector
	return Vector3(moyenne_x, moyenne_y, moyenne_z)

## destroy the fireball
func destroy():
	queue_free()

## When it enters into an area
## If it's a entity, destroy the fireball and deal damage
#func _on_area_3d_area_entered(area: Area3D) -> void:
#	
#	var main_node = area.get_parent_node_3d()
#	
#	if main_node.get_parent_node_3d().is_in_group("Creature"):
#		main_node.take_damage(damages)
#		
#	if main_node.get_parent_node_3d().is_in_group("Torch"):
#		main_node.isLit = true
#	
#	destroy()
	


func _on_area_3d_body_entered(body):
	
	if body.is_in_group("Creature"):
		body.take_damage(damages)
		
	if body.is_in_group("Boss"):
		body.take_damage(damages)
		
	if body.is_in_group("Torch"):
		body.isLit = true
	
	destroy()
