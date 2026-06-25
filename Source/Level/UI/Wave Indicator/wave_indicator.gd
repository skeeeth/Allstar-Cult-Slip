extends Control
class_name WaveIndicator

var home:Vector2

@export var icon: TextureRect
@export var label: Label

const self_scene:PackedScene = preload("uid://bn6wbpb2i5dd")

static func _create():
	return self_scene.instantiate()

func display(sprite:Texture2D,count:int):
	icon.texture = sprite
	label.text = "x %s " % count

func _process(delta: float) -> void:
	position = home.clamp(Vector2(0,0),Vector2(1920,1080))
