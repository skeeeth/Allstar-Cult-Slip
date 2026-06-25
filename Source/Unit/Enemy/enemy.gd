extends Unit
class_name Enemy

var data:EnemyData
@onready var navi: NavigationAgent2D = $Navi
@export var sprite:Sprite2D
var movespeed:float = 100

const _self_scene = preload("uid://4ppu28orsq7")

static func create(from_data:EnemyData) -> Enemy:
	var new_unit:Enemy = _self_scene.instantiate()
	new_unit.data = from_data
	new_unit.max_health = from_data.max_health
	new_unit.movespeed = from_data.movespeed
	new_unit.sprite.texture = from_data.sprite
	
	var source_ratio = new_unit.sprite.texture.get_size().aspect()
	var sprite_scale =from_data.size / new_unit.sprite.texture.get_size().x
	new_unit.sprite.scale.x = sprite_scale
	new_unit.sprite.scale.y = sprite_scale * source_ratio
	return new_unit

func _ready() -> void:
	hp_bar.value = current_health
	hp_bar.max_value = max_health
	navi.target_position = Vector2.ZERO
	died.connect(on_death)
	
	
func _physics_process(delta: float) -> void:
	if navi.is_target_reached():
		return
	var diff = navi.get_next_path_position() - global_position
	global_position += diff.normalized() * movespeed * delta
	navi.velocity = diff.normalized() * movespeed * delta
	

func on_death(_self):
	assert(_self == self)
	queue_free()
	
