extends Node2D
class_name Projectile
 
var target:Unit
var target_position:Vector2 = Vector2.ZERO
const threshold:float = 50.0
const linger_time:float = 0.2

var data:ProjectileData
var source_tower:Tower
const _self_scene = preload("uid://dvr2cvq6moi5m")
@export var shape_node:CollisionShape2D
@export var hitbox:Area2D
@export var sprite:TextureRect
var movespeed:float

static func create(d:ProjectileData,source:Tower)-> Projectile:
	var new_p:Projectile =  _self_scene.instantiate()
	new_p.data = d
	new_p.source_tower = source
	new_p.sprite.texture = d.sprite
	new_p.movespeed = d.speed
	if d.spash_size > 0:
		var collision_shape = CircleShape2D.new()
		collision_shape.radius = d.size
		new_p.shape_node.shape = collision_shape
	return new_p


func _process(delta: float) -> void:
	if target:
		target_position = target.global_position
	
	var diff:Vector2 = target_position - global_position
	if diff.length_squared() < threshold:
		clear()
		
		if data.spash_size > 0:
			if data.activation_type == ProjectileData.activation.END_EXPLODE:
				activate_hitbox()
		else:
			if target:
				source_tower.apply_effects(target)
		
	global_position += diff.normalized() * movespeed * delta

func clear():
	global_position = target_position
	
	self.create_tween().tween_callback(queue_free).set_delay(linger_time)

func activate_hitbox():
	if !hitbox.monitoring:
		hitbox.set_deferred("monitoring",true)

func _on_hitbox_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	assert(parent is Unit)
	
	#could do some sort of cooldown to prevent repeated hits
	source_tower.apply_effects(parent)
