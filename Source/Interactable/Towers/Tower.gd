extends Node2D
class_name Tower

var data:TowerData

const self_scene = preload("uid://bba0prqueb088")
var units_inside:Array[Unit]

var targets:Array[Unit]

var area_time:float = 0

static func create(from_data:TowerData) -> Tower: #Make sure to add to scene!
	var new_tower:Tower = self_scene.instantiate()
	new_tower.data = from_data
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
	match data.trigger_condition:
		TowerData.trigger_conditions.ENTRY:
			targets.append(u)
			trigger()
			targets.erase(u)
		TowerData.trigger_conditions.AREA_TIME:
			targets.append(u)
		TowerData.trigger_conditions.UNIT_TIME:
			pass
	
func unregister_unit(u:Unit):
	units_inside.erase(u)
	
func _process(delta: float) -> void:
	match data.trigger_condition:
		TowerData.trigger_conditions.AREA_TIME:
			area_time += delta
			if area_time >= data.trigger_time:
				trigger()
				area_time -= data.trigger_time
				


func trigger():
	for u in targets:
		u.take_damage(data.effect_strength)
