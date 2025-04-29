class_name MeleeWeapon

extends Weapon

@export var range : int # hit dstance

var position_t_moins_1 : Vector3
var velocity : Vector3
var last_damage_time : float
@export var velocity_norm : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_t_moins_1 = global_position
	velocity = Vector3(0,0,0)
	last_damage_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = (global_position - position_t_moins_1) / (delta)
	position_t_moins_1 = global_position


func _on_hitbox_area_entered(area: Area3D) -> void:
	var Type = area.get_parent_node_3d().get_parent_node_3d()
	if Type.name == "Entities":
		var velocity_norm = 200 * sqrt((velocity.x)**2 + (velocity.y)**2 + (velocity.z)**2)
		
		if Time.get_ticks_msec() - last_damage_time > fullAtkSpeed * 1000:
			var effective_damage = damages * velocity_norm / 2
			if effective_damage > 34:
				effective_damage = 34
			area.get_parent_node_3d().take_damage(floor(effective_damage))
			last_damage_time = Time.get_ticks_msec()
		
