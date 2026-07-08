extends Unit
class_name Player

@export var movespeed:float = 400
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $"Animated sprite"


func _process(delta: float) -> void:
	
	var dir = Input.get_vector("left", "right", "up","down")
	#position += dir * movespeed * delta
	nav.target_position = position + dir
	
	position += (nav.get_next_path_position() - position) * movespeed * delta
	camera_2d.position = position + (dir * movespeed * 0.3)
	
	#if sign(dir.x):
		#if sign(dir.y):
			#animated_sprite.play("Up Right")
		#else:
			#animated_sprite.play("Down Right")
	#else:
		#if sign(dir.y):
			#animated_sprite.play("Up Right")
		#else:
			#animated_sprite.play("Down Right")
	var animation_name:String
	animation_name = "Down " if sign(dir.y) else "Up "
	animation_name += "Right" if sign(dir.x) else "Left"
	print(animation_name)
	#try_play_animation(animation_name)
	
func try_play_animation(animation:String):
	if animated_sprite.animation == animation:
		return
	else:
		animated_sprite.play(animation)
