extends Node2D
class_name Unit


signal died #up to owner or parent to decide what happens on death


@export var max_health:float = 100
var current_health:float = max_health


func take_damage(amount:float):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	died.emit()
