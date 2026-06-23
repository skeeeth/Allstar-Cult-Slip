extends Unit
class_name Player

@export var movespeed:float = 400


func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up","down")
	position += dir * movespeed * delta
