extends Unit
class_name Player

@export var movespeed:float = 400
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $"Animated sprite"

var last_move_dir:Vector2

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
	if dir.length() > 0:
		animation_name = anim_name_from_vector(last_move_dir,false)
	else:
		animation_name = anim_name_from_vector(last_move_dir,true)
	
	last_move_dir.x = dir.x if dir.x != 0 else last_move_dir.x
	last_move_dir.y = dir.y if dir.y != 0 else last_move_dir.y
	
	try_play_animation(animation_name)
	

	
func try_play_animation(animation:String):
	if animated_sprite.animation == animation:
		return
	else:
		animated_sprite.play(animation)
