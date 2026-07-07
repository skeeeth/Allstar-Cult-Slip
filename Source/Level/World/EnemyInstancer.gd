extends Node

signal wave_spawned

@onready var wave_timer: Timer = $Timer
var scatter_range:float = 300

@export var enemy_pool:Array[EnemyData]
@export var spawn_points:Array[Node2D]
@export var moonlight:DirectionalLight2D
var next_point:Node2D
var next_type:EnemyData
@export var next_count:int = 4
var count_base:float = 4

@onready var hud: CanvasLayer = $"../Camera2D/Hud"
@onready var camera_2d: Camera2D = $"../Camera2D"
var next_delay:float = 0
@export var night_length:float = 5
@export var day_length:float = 5
var is_day:bool = true
var day_night_timer:Timer
@export var night_waves:int = 3
var waves_left:int = night_waves
const warning_time:float = 8

func _ready() -> void:
	#wave_timer.wait_time = next_delay
	wave_timer.timeout.connect(_on_timer_timeout)
	#determine_wave()
	
	day_night_timer = Timer.new()
	add_child(day_night_timer)
	day_night_timer.start(day_length)
	day_night_timer.timeout.connect(change_time)
	
	#for p in spawn_points:
		#var line = Line2D.new()
		#line.width = 3
		#line.add_point(Vector2.ZERO)
		#line.add_point(-p.position)
		#p.add_child(line)


func _on_timer_timeout() -> void:
	wave_timer.wait_time = next_delay
	wave_timer.start()
	
	#spawn_wave(next_point,next_type,next_count)
	if waves_left <= 0:
		return
	
	waves_left -= 1
	
	determine_wave()

func determine_wave():
	next_point =  spawn_points.pick_random()
	next_type = enemy_pool.pick_random()
	
	var indicator:WaveIndicator = WaveIndicator._create(warning_time,next_type,next_count)
	add_child(indicator)
	indicator.jitter = scatter_range
	indicator.camera = camera_2d
	indicator.display(next_type.sprite,next_count)
	indicator.home = next_point.position


##defunct, actually spawning is handled by WaveIndicator
#func spawn_wave(around_point:Node2D,data:EnemyData,count:int):
	#for i in range(0,count):
		#var new_enemy = Enemy.create(data)
		#var jitter = randf_range(0,scatter_range) * Vector2.from_angle(randf()*TAU)
		#new_enemy.position = around_point.position + jitter
		#add_child(new_enemy)
		
func change_time():
	if is_day:
		start_night()
	else:
		start_day()
		
func start_night():
	is_day = false
	day_night_timer.start(night_length)
	
	waves_left = night_waves
	next_delay = night_length / (night_waves * 1.5)
	var fade = create_tween()
	fade.tween_property(moonlight,"energy",0.6,1)
	wave_timer.start(next_delay)
	
func start_day():
	#be daytime
	day_night_timer.start(day_length)
	is_day = true
	
	#add difficulty
	count_base *= 1.2
	next_count = floor(count_base * next_type.wave_factor)


	wave_timer.stop()
	
	var fade = create_tween()
	fade.tween_property(moonlight,"energy",0.0,1)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_e"):
		determine_wave()
