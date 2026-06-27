extends Control
class_name WaveIndicator

var home:Vector2

@export var icon: TextureRect
@export var label: Label
var camera:Camera2D
const self_scene:PackedScene = preload("uid://bn6wbpb2i5dd")
static func _create():
	return self_scene.instantiate()

func display(sprite:Texture2D,count:int):
	icon.texture = sprite
	label.text = "x %s " % count

#var cc:Vector2 = Vector2.ZERO
#var diff:Vector2 = Vector2.ZERO
func _process(_delta: float) -> void:
	var screen_size = Vector2(1920,1080)
	var cc = camera.get_screen_center_position()
	global_position = home
	var diff = home - cc
	diff = diff.clamp((screen_size*-0.5),(screen_size*0.5)-size)
	global_position = cc + diff
