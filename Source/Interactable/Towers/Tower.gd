extends Node2D
class_name Tower

var data:TowerData

const self_scene = preload("uid://bba0prqueb088")
var units_inside:Array[Unit]

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
	
func unregister_unit(u:Unit):
	pass
	
