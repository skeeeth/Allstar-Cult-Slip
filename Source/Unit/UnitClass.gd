extends Node2D
class_name Unit


signal died(who) #up to owner or parent to decide what happens on death


@export var max_health:float = 100
@export var hp_bar:ProgressBar

@export var animated_sprite:AnimatedSprite2D

var current_health:float = max_health
var poison:int = 0

var poison_timer:Timer

func take_damage(amount:float, supress_sound:bool = false):
	current_health -= amount
	
	if hp_bar:
		#hp_bar.max_value = max_health
		hp_bar.value = current_health

	if current_health <= 0:
		die()

func slip(_amount:float):
	TriggerServer.unit_slipped.emit(self)

func die():
	died.emit(self)


func anim_name_from_vector(dir:Vector2,include_idle:bool = false) -> String:
	var animation_name:String
	animation_name = "Down " if sign(dir.y) == 1 else "Up "
	animation_name += "Right" if sign(dir.x) == 1 else "Left"
	
	if include_idle:
		animation_name += " Idle"# if dir.length() == 0 else ""
	
	return animation_name
	
func try_play_animation(animation:String):
	if animated_sprite.animation == animation:
		return
	else:
		animated_sprite.play(animation)
		

func add_poison(amount):
	if amount <= 0: #towers will apply 0 of an effect due to upgrade logic, dont do anything
		return
	
	if poison == 0:
		poison_timer = Timer.new()
		poison_timer.wait_time = 1.0
		poison_timer.timeout.connect(_on_poison_tick)
		add_child(poison_timer)
		poison_timer.start()
	
	poison += amount
	
func _on_poison_tick():
	take_damage(poison, true)
