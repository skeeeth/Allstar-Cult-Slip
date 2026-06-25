extends Node2D
class_name Base

var current_hp:float = 100

func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	assert(enemy is Enemy)
	if enemy is Enemy:
		enemy.take_damage(9999)
	current_hp -= 10.0
