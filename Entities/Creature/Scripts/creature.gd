class_name Creature

extends Entity

@export var damage : int ## Amount of damage it deals when attacking
@export var attackSpeed : float ## Number of seconds between two attacks
var drop : Array[Object] ## Array containing the items dropped once dead

@onready var time_last_deal_damage : float

@export var knockback_jump_force : float = 4.0
@export var knockback_force : float = 15
var knockback_velocity: Vector3 = Vector3.ZERO # Used for the knockback

func _ready() -> void:
	time_last_deal_damage = Time.get_ticks_msec() 
	add_to_group("Creature") # DO NOT REMOVE
	super._ready()
	#self.dialog()

# Say if the player took mob's aggro
func isMobAggro() -> bool:
	pass
	return false
	
func distanceEuclidienne(posA : Vector3, posB : Vector3):
	return sqrt(pow(posA.x - posB.x, 2) + pow(posA.y - posB.y, 2) + pow(posA.z - posB.z, 2))
	
	
func attack() -> void:
	var disToPlayer = distanceEuclidienne(position, player_scene.position)
	
	if Time.get_ticks_msec() - time_last_deal_damage > attackSpeed*1000:
		if aMode == aggressiveMode.MELEE:
			if disToPlayer <= melee_distance+0.2:
				# If we have an animation
				var anim_player = $AnimationPlayer if has_node("AnimationPlayer") else null
				if anim_player and anim_player is AnimationPlayer:
					var attacks = ["Attack1", "Attack2", "Attack3"]
					# We play a random attack
					var random_attack = attacks[randi() % attacks.size()]
					anim_player.play(random_attack)
				player_scene.damage_player(damage)
				time_last_deal_damage = Time.get_ticks_msec()
		elif aMode == aggressiveMode.DISTANCE:
			if disToPlayer <= dist_distance+0.5:
				var node_entities = get_tree().current_scene.get_node("Entities")
				var projectile_scene : Projectile = load("res://Items/Projectile/Scene/projectile.tscn").instantiate()
				projectile_scene.initial_position = global_position
				projectile_scene.destination = player_scene.global_position
				projectile_scene.speed = 10
				projectile_scene.damage = damage
				node_entities.add_child(projectile_scene)
				time_last_deal_damage = Time.get_ticks_msec()
		else :
			pass
			
		
	
## Reduce the heal point of the entity
func take_damage(damages : int):
	super.take_damage(damages)
	knockback_effect((global_transform.origin - player_scene.global_position).normalized(), knockback_force ,knockback_jump_force)

func _process(delta: float) -> void:
	var horizontal_knockback = Vector3(knockback_velocity.x, 0, knockback_velocity.z)
	if (horizontal_knockback.length() < 0.1):
		knockback_velocity.x = 0.0
		knockback_velocity.z = 0.0
		super._process(delta)
		attack()

# Used for the knockback
func _physics_process(delta: float) -> void:
	# Applique un amortissement progressif au knockback horizontal
	var horizontal_knockback = Vector3(knockback_velocity.x, 0, knockback_velocity.z)
	if horizontal_knockback.length() > 0.1:
		knockback_velocity.x = lerp(knockback_velocity.x, 0.0, delta * 5)
		knockback_velocity.z = lerp(knockback_velocity.z, 0.0, delta * 5)
		
		# Applique la gravité
		knockback_velocity.y -= gravity * delta  # Ajuste selon ta physique
		
		velocity = knockback_velocity
		move_and_slide()


func knockback_effect(direction: Vector3 = Vector3.BACK, force: float = 10.0, jump_strength: float = 4.0) -> void:
	var dir = direction.normalized()
	dir.y = 0  # On neutralise la hauteur dans la direction de base (on va la gérer à part)
	knockback_velocity = dir * force
	knockback_velocity.y = jump_strength
	
