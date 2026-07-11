extends PanelContainer
class_name Leaderboard


@export var scores_displayed:int = 4
@onready var entries: Label = $VBoxContainer/Entries




func display_scores():
	#could do some sort of entry animation if you want
	visible = true
	
	var text:String = ""
	#assume scores are already sorted and cropped
	for i in range(0,Scoring.live_scores.size()):
		var e = Scoring.live_scores[i]
		text += "%s: %s \n" % [e["Name"], e["Score"]]
		
	entries.text = text





func load_scores():
	#IDK MAN DO I REALLY GIVE A SHIT
	pass


func _on_button_pressed() -> void:
	Scoring.reset_game()
	
	pass # Replace with function body.
