extends Sprite3D


@onready var entity_scene = get_parent()

var maxHP : float 

func _ready():
	maxHP = entity_scene.hpMax
	texture = load("res://UI/Textures/HPBar.tres").duplicate(true) # Deep copy : each NPC will have its own HPBar texture
	texture.gradient.set_offset(1,entity_scene.hp/maxHP)

func _process(delta):
	#print("Mon parent est : ",entity_scene.name)
	#value is between 0 (0 hp) and 1 (full hp)
	texture.gradient.set_offset(1,entity_scene.hp/maxHP)
