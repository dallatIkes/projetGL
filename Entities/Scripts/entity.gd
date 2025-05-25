class_name Entity

extends CharacterBody3D

enum races {
	Human,
	Dwarf,
	Dog,
	Goblin,
	BOSS
}

enum passiveMode {
	STILL, ## It stays still
	CAMP,  ## It randomly moves in a certain zone
	FOLLOWING_PATH ## It follows a precalculed path
}

enum aggressiveMode {
	STILL, ## It stays still
	FLEEING, ## It flies from the player
	DISTANCE, ## It stays at a precalculated distance from the player to use range weapons
	MELEE, ## It comes to the player to use melee weapons
	DISTMELEE ## It stays away from the player until they reach a limit, then it comes to them
}
	
enum targetingMode {
	NEAR, ## It targets the player when they enters his field of view
	INTERACTION, ## It targets the player when they interacts with it
	ATTACK ## It targets the player in response of its atatck
}

@onready var player_scene = get_tree().current_scene.get_node("Player")

@export var race : races ## The entity's race
@export var description : String ## A brief description of the entity's lore
@export var hpMax : int ## The maximum amount of health points
var hp : int ## The current amount of health points
@export var isInvincible : bool ## Defines wheather or not it can die
@export var isTrackingPlayer : bool ## Definies wheter or not it follows the player


@export var speed : int ## Defines the entity's speed
# String needed for animation
@export var walkingAnimation : String
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var mesh_instance_3d = $MeshInstance3D


var last_time_ptarg_pos_chg : float
var time_reach_targ_pos : float
var gravity: float = 9.8

@export_group("Behavior")

# entity mode 
@export_subgroup("Choose Behavior")
@export var pMode : passiveMode
@export var aMode : aggressiveMode
@export var tMode : targetingMode


# variable for camp behavior in passive mode
@export_subgroup("Camp passive mode")
@onready var spawn_point : Vector3 = position
@export var radius : float ## Radius of the zone, it randomly moves in

# variable for following path behavior in passive mode
@export_subgroup("Following path passive mode")
@export var list_of_position : Array ## Array containing the coordinates the entity has to reach along its path
var current_position_in_list : int
@export var reverse : int ## Refer to the passive_movement func doc (may change later)

# variable for aggressive mode
@export_subgroup("Aggressive mode")
var position_status_change : Array
@export var melee_distance : float ## Distance under which the entity attacks in melee
@export var dist_distance : float ## Distance at which the entity wants shoot the player
@export var stop_fleeing_distance : float ## Distance at which the entity will stop targeting the player



## Call the good function in fonction of the targeting mode of the entity
func movement()->Vector3:
	var res : Vector3
	if isTrackingPlayer == true:
		res = aggressive_movement()
		#print("res aMode", res)
	else:
		res = passive_movement()
		#print("res pMode", res)
	return res


## Return the position to target in function of the aggressive behavior
func aggressive_movement() -> Vector3:
	var res : Vector3
	var player_position = player_scene.global_position
	if aMode == aggressiveMode.STILL:
		res = MovementAggressive.stillBehavior(position)
	elif aMode == aggressiveMode.FLEEING:
		res = MovementAggressive.fleeingBehavior(position, player_position, stop_fleeing_distance)
	elif aMode == aggressiveMode.DISTANCE:
		res = MovementAggressive.distanceBehavior(position, player_position, position_status_change)
	elif aMode == aggressiveMode.MELEE:
		res = MovementAggressive.meleeBehavior(position, player_position, position_status_change)
	elif aMode == aggressiveMode.DISTMELEE:
		res = MovementAggressive.meleeDistBehavior(position, player_position, position_status_change)
	else:
		res = position
	return res
	

## Return the position to target in function of the passive behavior
func passive_movement()->Vector3:
	var res : Vector3
	if pMode == passiveMode.STILL:
		res = MovementPassive.stillBehavior(position)
	elif pMode == passiveMode.CAMP:
		res = MovementPassive.campBehavior(position, rotation, spawn_point, radius)
	elif pMode == passiveMode.FOLLOWING_PATH:
		var tmp = MovementPassive.followingPathBehavior(list_of_position, current_position_in_list, reverse)
		res = tmp[0]
		current_position_in_list = tmp[1]
		reverse = tmp[2]
	else:
		res = position
	return res


## Set targeting mode
func setTarget():
	if tMode == targetingMode.NEAR:
		if Movement.distanceVect(position, player_scene.global_position) < stop_fleeing_distance:
			isTrackingPlayer = true
		elif Movement.distanceVect(position, player_scene.global_position) > stop_fleeing_distance and isTrackingPlayer:
			navigation_agent_3d.target_position = spawn_point
			isTrackingPlayer = false
			
	
## Set the position to target into variable target_position 
func set_new_pos()->void:
	navigation_agent_3d.target_position = movement()
	last_time_ptarg_pos_chg = Time.get_ticks_msec()
	time_reach_targ_pos = Time.get_ticks_msec()
	
	#print("res2 ->", navigation_agent_3d.target_position)


## Reduce the heal point of the entity
func take_damage(damages : int):
	if !isInvincible:
		hp -= damages
		damage_effect()
		if (hp <= 0):
			queue_free()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Entity")
	hp = hpMax; #hp initialization
	current_position_in_list = 0
	isTrackingPlayer = false
	last_time_ptarg_pos_chg = Time.get_ticks_msec()
	time_reach_targ_pos = Time.get_ticks_msec()
	position_status_change = [melee_distance, dist_distance]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	setTarget() # set the targeting mode (if the player is detect or not)
	
	# Set the new target position (different case in function of the behavior)
	if isTrackingPlayer == false:
		if pMode == passiveMode.CAMP:
			if navigation_agent_3d.is_navigation_finished() or Time.get_ticks_msec()-last_time_ptarg_pos_chg > 5000 :
					if Time.get_ticks_msec() - time_reach_targ_pos > 3000:
						set_new_pos()
	else:
		set_new_pos()
	
	# Set velocity to the entity in function of the position target
	velocity = global_position.direction_to(navigation_agent_3d.get_next_path_position()) * speed
	
	# Add gravity to the entity
	if is_on_floor() == false:
		velocity += get_gravity() * delta

	var animation_player = get_node_or_null("AnimationPlayer")
	var horizontal_velocity = Vector2(velocity.x, 0)

	if horizontal_velocity.length() > 1:
		var move_dir = velocity.normalized()
		var target_rotation_y = atan2(move_dir.x, move_dir.z)
		
		rotation.y = lerp_angle(rotation.y, target_rotation_y, 0.1) # 0.1 = rotation speed

	if animation_player:
		if horizontal_velocity.length() > 1:
			if not animation_player.is_playing():
				animation_player.play(walkingAnimation)
		else:
			if animation_player.is_playing() and animation_player.current_animation == walkingAnimation:
				animation_player.pause()


	var target_pos = navigation_agent_3d.get_next_path_position()
	target_pos.y = global_position.y  # on annule la différence de hauteur
	velocity = global_position.direction_to(target_pos) * speed

	if not is_on_floor():
		velocity.y -= gravity * delta

	# move entity
	move_and_slide()
	
# Called in order to put a damage effect on the mob by becoming red
func damage_effect() -> void:
	if mesh_instance_3d :
		var precedent_material = mesh_instance_3d.get_surface_override_material(0) # We stock the current used material
		mesh_instance_3d.set_surface_override_material(0,load("res://Entities/Effects/damage_effect.tres").duplicate(true))
		await get_tree().create_timer(0.2).timeout # Waiting 0.5 seconds
		mesh_instance_3d.set_surface_override_material(0,precedent_material)
