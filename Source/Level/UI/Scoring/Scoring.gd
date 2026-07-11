extends Node

signal game_reseting
signal score_changed
signal game_loss

var breakdown:Dictionary[String,float]



var live_scores:Array[Dictionary] = [
	{"Name": "AAA",
	 "Score": 100},
	{"Name": "ccc",
	 "Score": 200},
	{"Name": "bBb",
	 "Score": 300},
]

var scores_displayed:int = 4

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
	
	for r in ResourceManager.current:
		ResourceManager.current[r] = 0
	#get_tree().reload_current_scene()
	get_tree().change_scene_to_file("res://Source/Level/Title/title.tscn")
	pass

func end_game():
	game_loss.emit()

func add_entry(entry_name:String, score:float):
	
	var entry_data:Dictionary
	entry_data["Name"] = entry_name
	entry_data["Score"] = score
	
	live_scores.append(entry_data)
	
	var score_sort = func s_sort(a:Dictionary,b:Dictionary):
		return a["Score"] > b["Score"]
	
	live_scores.sort_custom(score_sort)
	live_scores.resize(scores_displayed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_r"):
		reset_game()
		
