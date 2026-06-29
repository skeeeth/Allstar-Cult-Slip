extends Node2D
class_name Unit


signal died(who) #up to owner or parent to decide what happens on death


@export var max_health:float = 100
@export var hp_bar:ProgressBar

var current_health:float = max_health


func take_damage(amount:float):
	current_health -= amount
	
	if hp_bar:
		#hp_bar.max_value = max_health
		hp_bar.value = current_health

	if current_health <= 0:
		die()

func slip(amount:float):
	pass

func die():
	died.emit(self)
