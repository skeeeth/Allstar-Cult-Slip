extends Unit
class_name Player

@export var movespeed:float = 400
@onready var camera_2d: Camera2D = $"../Camera2D"


func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up","down")
	position += dir * movespeed * delta
	
	camera_2d.position = position + (dir * movespeed * 0.3)
