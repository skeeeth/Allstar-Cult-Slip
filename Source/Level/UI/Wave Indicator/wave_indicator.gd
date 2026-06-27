extends Control
class_name WaveIndicator

var home:Vector2

@export var icon: TextureRect
@export var label: Label
var camera:Camera2D
const self_scene:PackedScene = preload("uid://bn6wbpb2i5dd")
@export var progress_bar: ProgressBar
var time_alive = 0
static func _create(set_delay:float = 1.0):
	var new_display = self_scene.instantiate()
	new_display.progress_bar.max_value = set_delay
	new_display.progress_bar.value = set_delay
	return new_display

func display(sprite:Texture2D,count:int):
	icon.texture = sprite
	label.text = "x %s " % count

#var cc:Vector2 = Vector2.ZERO
#var diff:Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var screen_size = Vector2(1920,1080)
	var cc = camera.get_screen_center_position()
	global_position = home
	var diff = home - cc
	diff = diff.clamp((screen_size*-0.5),(screen_size*0.5)-size)
	global_position = cc + diff
	
	time_alive += delta
	progress_bar.value = progress_bar.max_value - time_alive
	#print(progress_bar.value)
	if progress_bar.value <= 0:
		queue_free()
