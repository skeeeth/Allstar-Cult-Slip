extends Unit

func _ready() -> void:
	hp_bar.value = current_health
	hp_bar.max_value = max_health
