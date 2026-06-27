extends Unit
class_name Player

@export var movespeed:float = 400
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var nav: NavigationAgent2D = $NavigationAgent2D


func _process(delta: float) -> void:
	
	var dir = Input.get_vector("left", "right", "up","down")
	#position += dir * movespeed * delta
	nav.target_position = position + dir
	
	position += (nav.get_next_path_position() - position) * movespeed * delta
	camera_2d.position = position + (dir * movespeed * 0.3)
