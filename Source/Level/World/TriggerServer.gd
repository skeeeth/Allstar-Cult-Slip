extends Node

@warning_ignore("unused_signal")
signal unit_slipped(who)
@warning_ignore("unused_signal")
signal poison_death(who)
@warning_ignore("unused_signal")
signal poison_applied(amount, to_who)

func add_trigger(script:Script):
	add_child(script.new())
	pass

func _ready() -> void:
	Scoring.game_reseting.connect(game_reset)

func game_reset():
	for i in get_children():
		i.queue_free()
