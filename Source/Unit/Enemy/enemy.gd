extends Unit

@onready var navi: NavigationAgent2D = $Navi

var movespeed:float = 100

func _ready() -> void:
	hp_bar.value = current_health
	hp_bar.max_value = max_health
	navi.target_position = Vector2.ZERO
	
	
func _physics_process(delta: float) -> void:
	if navi.is_target_reached():
		return
	var diff = navi.get_next_path_position() - global_position
	global_position += diff.normalized() * movespeed * delta
	navi.velocity = diff.normalized() * movespeed * delta
	
