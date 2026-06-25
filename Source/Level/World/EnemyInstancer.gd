extends Node

@onready var wave_timer: Timer = $Timer
var scatter_range:float = 300

@export var enemy_pool:Array[EnemyData]
@export var spawn_points:Array[Node2D]
var next_point:Node2D
var next_type:EnemyData
@export var next_count:int = 4

func _ready() -> void:
	determine_wave()
	

func _on_timer_timeout() -> void:
	wave_timer.wait_time = 5
	wave_timer.start()
	
	spawn_wave(next_point,next_type,next_count)
	determine_wave()

func determine_wave():
	next_point =  spawn_points.pick_random()
	next_type = enemy_pool.pick_random()
	next_count *= 1.2

func spawn_wave(around_point:Node2D,data:EnemyData,count:int):
	for i in range(0,count):
		var new_enemy = Enemy.create(data)
		var jitter = randf_range(0,100) * Vector2.from_angle(randf()*TAU)
		new_enemy.position = around_point.position + jitter
		add_child(new_enemy)
