extends Control


@export var breakdown: Label


func _ready() -> void:
	Scoring.game_loss.connect(display)
		


func display():
	visible = true
	for entry in Scoring.breakdown:
		breakdown.text += "%s: %s" % [entry,Scoring.breakdown[entry]]
