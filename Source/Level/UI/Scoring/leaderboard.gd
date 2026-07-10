extends PanelContainer
class_name Leaderboard


@export var scores_displayed:int = 4
@onready var entries: Label = $VBoxContainer/Entries

var live_scores:Array[Dictionary] = [
	{"Name": "AAA",
	 "Score": 100},
	{"Name": "ccc",
	 "Score": 200},
	{"Name": "bBb",
	 "Score": 300},
]


func display_scores():
	#could do some sort of entry animation if you want
	visible = true
	
	var text:String = ""
	#assume scores are already sorted and cropped
	for i in range(0,live_scores.size()):
		var e = live_scores[i]
		text += "%s: %s \n" % [e["Name"], e["Score"]]
		
	entries.text = text


func add_score(entry_name:String, score:float):
	
	var entry_data:Dictionary
	entry_data["Name"] = entry_name
	entry_data["Score"] = score
	
	live_scores.append(entry_data)
	
	var score_sort = func s_sort(a:Dictionary,b:Dictionary):
		return a["Score"] > b["Score"]
	
	live_scores.sort_custom(score_sort)
	live_scores.resize(scores_displayed)


func load_scores():
	#IDK MAN DO I REALLY GIVE A SHIT
	pass


func _on_button_pressed() -> void:
	Scoring.reset_game()
	
	pass # Replace with function body.
