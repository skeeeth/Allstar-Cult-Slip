extends Control
class_name WaveIndicator

var home:Vector2

@export var icon: TextureRect
@export var label: Label
var camera:Camera2D
const self_scene:PackedScene = preload("uid://bn6wbpb2i5dd")
@export var progress_bar: ProgressBar
@export var wave_sound_effect:AudioStream

var time_alive = 0
var quota:int
var interval:float = 0.1
var type:EnemyData

var jitter:float = 100

static func _create(set_delay:float, _type:EnemyData,count:int):
	var new_display = self_scene.instantiate()
	new_display.type = _type
	new_display.quota = count
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
	if progress_bar.value <= 0 and visible:
		visible = false
		var new_tween = self.create_tween()
		new_tween.tween_callback(instance_unit).set_delay(interval)
		new_tween.set_loops(quota)
		new_tween.finished.connect(queue_free)

func instance_unit():
	var new_enemy:Enemy = Enemy.create(type);
	var jitter_vector = Vector2.from_angle(randf() * TAU)
	jitter_vector *= jitter * randf()
	new_enemy.position = home + jitter_vector
	add_sibling(new_enemy)
