extends Node2D
class_name Tower

var data:TowerData

const self_scene = preload("uid://bba0prqueb088")
var units_inside:Array[Unit]
@export var sprite: Sprite2D
@export var animated_sprite:AnimatedSprite2D

var targets:Array[Unit]
var max_targets:int = 1

var area_time:float = 0
var target_time:Dictionary[Unit,float]
@export var range_shape: CollisionShape2D
@onready var shockwave: CPUParticles2D = $Shockwave

static func create(from_data:TowerData) -> Tower: #Make sure to add to scene!
	var new_tower:Tower = self_scene.instantiate()
	new_tower.data = load(from_data.resource_path)
	
	var circle = CircleShape2D.new()
	circle.radius = from_data.area_size
	new_tower.range_shape.shape = circle
	
	new_tower.sprite.texture = from_data.sprite
	var x_fit = from_data.draw_size / from_data.sprite.get_size().x
	new_tower.sprite.scale = Vector2(x_fit,x_fit)
	new_tower.animated_sprite.sprite_frames = from_data.frames
	new_tower.animated_sprite.scale = new_tower.sprite.scale
	new_tower.animated_sprite.play("default")
	for i in range(1,from_data.draw_count):
		var new_sprite = new_tower.animated_sprite.duplicate()
		new_tower.add_child(new_sprite)
		new_sprite.position += Vector2.from_angle(randf() * TAU) * \
				lerp(0.2,0.4,randf())  * from_data.draw_size
		var animations = new_sprite.sprite_frames.get_animation_names()
		new_sprite.play(animations[randi_range(0,animations.size()-1)])
	return new_tower


func _on_effect_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	assert(parent is Unit)
	register_unit(parent)

func _on_effect_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	assert(parent is Unit)
	unregister_unit(parent)
	
func register_unit(u:Unit):
	units_inside.append(u)
	u.died.connect(unregister_unit)
	match data.trigger_condition:
		TowerData.trigger_conditions.ENTRY:
			targets.append(u)
			u.create_tween().tween_callback(\
					trigger_single.bind(u)).set_delay(
							data.trigger_time * randf())
			#trigger_single(u)
			targets.erase(u)
		TowerData.trigger_conditions.AREA_TIME:
			targets.append(u)
		TowerData.trigger_conditions.UNIT_TIME:
			set_target_last()
	
func unregister_unit(u:Unit):
	units_inside.erase(u)
	targets.erase(u)
	target_time.erase(u)
	set_target_last()

func _process(delta: float) -> void:
	match data.trigger_condition:
		TowerData.trigger_conditions.AREA_TIME:
			area_time += delta
			if area_time >= data.trigger_time:
				shockwave.emitting = true ## BAD COUPLED CODE, ONLY FOR TREE
				trigger_all()
				area_time -= data.trigger_time
		TowerData.trigger_conditions.UNIT_TIME:
			for u in targets:
				target_time[u] += delta
				if target_time[u] >= data.trigger_time:
					target_time[u] -= data.trigger_time
					trigger_single(u)
					


func trigger_all():
	for u in targets:
		trigger_single(u)
		

func trigger_single(u:Unit):
	
	##fire projectile if tower is projectile type
	if data.projectile:
		fire_projectile(u)
		return 
	
	##just do the thing otherwise
	apply_effects(u)
	
func apply_effects(target:Unit):
	var read_effects:Dictionary = data.effects.duplicate_deep()
	
	for bonus in data.effect_mod:
		if read_effects.has(bonus):
			read_effects[bonus] += data.effect_mod[bonus]
		else:
			read_effects[bonus] = data.effect_mod[bonus]
	
	for e in read_effects:
		match e:
			TowerData.effect_types.DAMAGE:
				target.take_damage(read_effects[e])
			TowerData.effect_types.SLIP:
				target.slip(read_effects[e])

func fire_projectile(target:Unit):
	var new_projectile = Projectile.create(data.projectile,self)
	add_child(new_projectile)
	new_projectile.target = target

func set_target_last():
	if targets.size() < max_targets and units_inside.size() > 0:
		if data.trigger_condition == TowerData.trigger_conditions.UNIT_TIME:
			var u = units_inside.back()
			if u == null: return
			targets.append(u)
			target_time[u] = 0.0
