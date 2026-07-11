extends Control

@export var leaderboard:Leaderboard
#@onready var text_edit: TextEdit = $VBoxContainer/TextEdit

@export var breakdown_slots:VBoxContainer
#@export var breakdown_label: Label
@export var running_total:Label
@onready var line_edit: LineEdit = $VBoxContainer/LineEdit

func _ready() -> void:
	Scoring.game_loss.connect(display)

func display():
	visible = true
	var breakdown = create_tween()
	var sum:float = 0
	
	var full_add = func fa(category:String):
		var new_BE = BreakdownEntry._create(category,Scoring.breakdown[category])
		breakdown_slots.add_child(new_BE)
	
	for entry in Scoring.breakdown:
		sum += Scoring.breakdown[entry]
		breakdown.tween_callback(full_add.bind(entry))
		breakdown.parallel().tween_property(running_total,"text","%.0f" % sum,0.5)
	
	breakdown.tween_property(line_edit,"editable",true,0.1)
	breakdown.tween_callback(line_edit.grab_focus)


func _on_line_edit_text_submitted(new_text: String) -> void:
	#leaderboard.add_score(new_text,Scoring.get_total_score())
	Scoring.add_entry(new_text,Scoring.get_total_score())
	leaderboard.display_scores()
	hide()
