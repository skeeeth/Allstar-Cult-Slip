extends Node

signal game_reseting
signal score_changed
signal game_loss

var breakdown:Dictionary[String,float]

func save_data():
	pass

func add_score(amount:float, category:String):
	score_changed.emit()
	if breakdown.has(category):
		breakdown[category] += amount
	else:
		breakdown[category] = amount

func get_total_score() -> float:
	var total:float = 0
	for k in breakdown:
		total += breakdown[k]
	return total

func reset_game():
	game_reseting.emit()
	get_tree().reload_current_scene()
	pass

func end_game():
	game_loss.emit()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_r"):
		ResourceManager.current.clear()
		end_game()
