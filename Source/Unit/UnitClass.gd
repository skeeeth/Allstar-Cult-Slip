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

func slip(_amount:float):
	pass

func die():
	died.emit(self)


func anim_name_from_vector(dir:Vector2,include_idle:bool = false) -> String:
	var animation_name:String
	animation_name = "Down " if sign(dir.y) == 1 else "Up "
	animation_name += "Right" if sign(dir.x) == 1 else "Left"
	
	if include_idle:
		animation_name += " Idle"# if dir.length() == 0 else ""
	
	return animation_name
