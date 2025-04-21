class_name ForestBoss

extends Entity

# Spell scene
var spell_scene = preload("res://Spells/PoisonBall/Scene/PoisonBall.tscn") 
# Mob scene
var mob_scene = preload("res://Entities/Creature/Scenes/Tuto.tscn") 

# Audio node
@onready var audiosteamplayer = $AudioStreamPlayer

# Player
@onready var player = get_tree().current_scene.get_node("Player");

@export var time_between_1st_attack_and_2nd = 3.0 # 3 seconds
@export var time_between_2nd_attack_and_1st = 15.0
@export var number_of_launched_spells = 10
@export var time_between_spells = 1.0 # 1 second
@export var number_of_spawned_mobs = 5
@export var minimum_distance_for_spawning_mobs = 5.0 # 5 meters
@export var maximum_distance_for_spawning_mobs = 15.0 # 5 meters
@export var time_between_spawning_mobs = 2.0

var TAU = 2 * PI # for the second attack pattern

var not_launched_battle_phase = true # if true : the boss fight hasn't started. 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Boss") # DO NOT REMOVE
	super._ready()
	#stop_fleeing_distance = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if isTrackingPlayer and not_launched_battle_phase:
		not_launched_battle_phase = false
		audiosteamplayer.play()
		boss_fight()
	
	if !isTrackingPlayer and !not_launched_battle_phase: # if the player leave
		audiosteamplayer.stop()
		hp = hpMax
		not_launched_battle_phase = true

func boss_fight():
	while(isTrackingPlayer):
		if isTrackingPlayer: # we need to check if the player is still in the boss' place
			await throw_on_player()
		if isTrackingPlayer:
			await get_tree().create_timer(time_between_1st_attack_and_2nd).timeout # wait time_between_1st_attack_and_2nd seconds
		if isTrackingPlayer:
			await spawn_mob_around_player()
		if isTrackingPlayer:
			await get_tree().create_timer(time_between_2nd_attack_and_1st).timeout
	audiosteamplayer.stop()

# first attack pattern
func throw_on_player():
	for i in range(number_of_launched_spells):
		
		var player_pos = player.global_position
		# Spell instantiation
		var spell_instance = spell_scene.instantiate()
		# Spell positioning
		spell_instance.global_position = player_pos
		# Adding the spell to the scene
		get_tree().current_scene.add_child(spell_instance)
		if !isTrackingPlayer:
			audiosteamplayer.stop()
			break
		await get_tree().create_timer(time_between_spells).timeout  # Waiting time_between_spells seconds

# second attack pattern
func spawn_mob_around_player():
	for i in range(number_of_spawned_mobs):
		var player_pos = player.global_position

		# Random angle (radians)
		var angle = randf() * TAU  # TAU = 2 * PI (toutes les directions possibles)

		# Random distance between 10 and 20 meters
		var distance = randf_range(minimum_distance_for_spawning_mobs, maximum_distance_for_spawning_mobs)

		# Position around the player
		var spawn_pos = player_pos + Vector3(cos(angle) * distance, 0, sin(angle) * distance)
		
		var mob_instance = mob_scene.instantiate()
		
		mob_instance.global_position = spawn_pos
		# Adding the mob to the scene
		get_tree().current_scene.add_child(mob_instance)
		if !isTrackingPlayer:
			audiosteamplayer.stop()
			break
		await get_tree().create_timer(time_between_spawning_mobs).timeout  # Waiting time_between_spawning_mobs seconds
