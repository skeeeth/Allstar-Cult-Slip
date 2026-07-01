extends Node2D
class_name Tower

var data:TowerData

const self_scene = preload("uid://bba0prqueb088")
var units_inside:Array[Unit]
@export var sprite: Sprite2D

var targets:Array[Unit]
var max_targets:int = 1

var area_time:float = 0
var target_time:Dictionary[Unit,float]
@export var range_shape: CollisionShape2D

static func create(from_data:TowerData) -> Tower: #Make sure to add to scene!
	var new_tower:Tower = self_scene.instantiate()
	new_tower.data = from_data
	var circle = CircleShape2D.new()
	circle.radius = from_data.area_size
	new_tower.range_shape.shape = circle
	new_tower.sprite.texture = from_data.sprite
	
	return new_tower


func _on_effect_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	assert(parent is Unit)
	register_unit(parent)
	pass # Replace with function body.

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
	for e in data.effects.keys():
		match e:
			TowerData.effect_types.DAMAGE:
				u.take_damage(data.effects[e])
			TowerData.effect_types.SLIP:
				u.slip(data.effects[e])
	u.take_damage(data.effect_strength)
	
func set_target_last():
	if targets.size() < max_targets and units_inside.size() > 0:
		if data.trigger_condition == TowerData.trigger_conditions.UNIT_TIME:
			var u = units_inside.back()
			if u == null: return
			targets.append(u)
			target_time[u] = 0.0
