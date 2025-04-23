class_name PlayerScript

extends Node3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5

enum SpellEnum {FIREBALL, ## Spell fireball
				HEALORB, ## Spell heal orb
				ELECTRICARC, ## Spell electric arc
				NOTHING
				}
var selected_spell : SpellEnum = SpellEnum.NOTHING ## The variable where the selected spell is save

var spellUnlock = {
					"FIREBALL": false, 
					"HEALORB": false,
					"ELECTRICARC": false
				}
				



# Références des noeuds enfants
@onready var camera: Camera3D = $Camera
@onready var left_hand: Node3D = $LeftHand
@onready var right_hand: Node3D = $RightHand

enum Hands {
	LEFT,
	RIGHT
}
var main_hand : Hands = Hands.RIGHT

@onready var sfx1 = $"sfx1"
@onready var sfx2 = $"sfx2"

# @export var name : String
@export var stats : Statistics = Statistics.new()

# Delete this variable when Statistics will be implemented
@export var hpMax : int
var hp : int

@export var manaMax : int
var mana : int
var t_recharge_mana ## last time the mana was regen

# @export var armorSet : Set
var inventory : Array[Object]

func _ready():
	mana = manaMax
	hp = hpMax/3
	t_recharge_mana = Time.get_ticks_msec()
	add_to_group("Player") # DO NOT REMOVE
	


## Function which regen the the number of manapoint every second (replace this function later)
func recharge_mana():
	if mana+2 < manaMax:
		if Time.get_ticks_msec()-t_recharge_mana>1000:
			mana +=10
			t_recharge_mana = Time.get_ticks_msec()


func _on_equipment(new_stats:Variant) -> void:
	stats.HP += new_stats.HP
	stats.ATK += new_stats.ATK
	stats.DEF += new_stats.DEF
	stats.speed += new_stats.speed
	stats.ATKSpeed *= new_stats.ATKSpeed
	
func _on_unequipment(old_stats:Variant) -> void:
	stats.HP -= old_stats.HP
	stats.ATK -= old_stats.ATK
	stats.DEF -= old_stats.DEF
	stats.speed -= old_stats.speed
	stats.ATKSpeed /= old_stats.ATKSpeed


## return the scene of the spell to instantiate in function of the variable SpellEnum
func which_spell():
	if selected_spell == SpellEnum.FIREBALL:
		return "res://Spells/Scenes/fire_ball.tscn"
	elif selected_spell == SpellEnum.HEALORB:
		return "res://Spells/Scenes/heal_orb.tscn"
	elif selected_spell == SpellEnum.ELECTRICARC:
		return "res://Spells/Scenes/electric_arc.tscn"
	elif selected_spell == SpellEnum.NOTHING:
		return ""


## Reduce the number of manapoint (function call by spells)
func lost_mana(mana_point_consume : int)->bool:
	if mana - mana_point_consume < 0:
		return false
	else :
		mana -= mana_point_consume
		return true

## Heal the player
func heal_player(heal_point: int):
	hp += heal_point
	if hp > hpMax:
		hp = hpMax

## Gave damage to the player
func damage_player(damages: int):
	hp -= damages
	if hp < 0:
		pass

	randomize()  # Initialise the random number generator
	var result = randi_range(1, 2)  #Generate 1 or 2
	if(result == 1):
		if sfx1 :
			sfx1.play()
	else : 
		if sfx2:
			sfx2.play()



"""
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
"""
