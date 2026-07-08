extends Unit
class_name Enemy

var data:EnemyData
@onready var navi: NavigationAgent2D = $Navi
@onready var hit_sound: AudioStreamPlayer2D = $Hit

@export var sprite:AnimatedSprite2D
var movespeed:float = 100

@export var boid_strength:float
var neighbors:Array[Enemy]

const _self_scene = preload("uid://4ppu28orsq7")

static func create(from_data:EnemyData) -> Enemy:
	var new_unit:Enemy = _self_scene.instantiate()
	new_unit.data = from_data
	new_unit.max_health = from_data.max_health
	new_unit.movespeed = from_data.movespeed
	new_unit.sprite.sprite_frames = from_data.sprite
	
	var source_ratio = new_unit.sprite.texture.get_size().aspect()
	var sprite_scale =from_data.size / new_unit.sprite.texture.get_size().x
	new_unit.sprite.scale.x = sprite_scale
	new_unit.sprite.scale.y = sprite_scale * source_ratio
	return new_unit

func _ready() -> void:
	hp_bar.max_value = max_health
	current_health = max_health
	hp_bar.value = current_health

	navi.target_position = Vector2.ZERO
	died.connect(on_death)
	

func _physics_process(delta: float) -> void:
	if navi.is_target_reached():
		return
	#var avoid:Vector2 = Vector2.ZERO
	#
	#for neighbor in neighbors:
		#if !neighbor: continue
		#var aa:Vector2 = Vector2.ZERO
		#aa = (global_position - neighbor.global_position)
		#aa *= lerp(5.0,0.1,avoid.length()/data.size)
		#avoid += aa
	#
	#avoid *= boid_strength
	#avoid = avoid.clamp(Vector2(-movespeed,-movespeed),Vector2(movespeed,movespeed))
	var nav_diff = navi.get_next_path_position() - global_position
	var target_position:Vector2 = global_position + nav_diff# + avoid
	
	var diff = target_position - global_position
	global_position += diff.normalized() * movespeed * delta
	#navi.velocity = diff.normalized() * movespeed * delta
	

func on_death(_self):
	assert(_self == self)
	Scoring.add_score(max_health, "Enemy Killed")
	queue_free()
	

func slip(amount:float):
	
	var startup = 0.05
	var slipping = self.create_tween()
	slipping.set_ease(Tween.EASE_IN_OUT)
	slipping.tween_property(sprite,"rotation",PI/2.0,startup).set_trans(Tween.TRANS_BOUNCE)
	slipping.parallel().tween_property(self,"movespeed",0.0,startup*1.3)
	
	
	slipping.tween_property(self,"movespeed",movespeed,startup).set_delay(amount+startup)
	slipping.parallel().tween_property(sprite,"rotation",0,startup).set_delay(amount)


func take_damage(amount:float):
	hit_sound.play()
	super(amount)
	
#func _on_boid_area_area_entered(area: Area2D) -> void:
	#var parent = area.get_parent()
	#assert(parent is Enemy)
	#if parent is Enemy:
		#parent.died.connect(neighbors.erase)
	#neighbors.append(parent)


#func _on_boid_area_area_exited(area: Area2D) -> void:
	#var parent = area.get_parent()
	#if parent is Enemy:
		#if parent.died.is_connected(neighbors.erase):
			#parent.died.disconnect(neighbors.erase)
	#
	#neighbors.erase(area.get_parent())
