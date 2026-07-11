extends Node

@warning_ignore("unused_signal")
signal unit_slipped(who)


func add_trigger(script:Script):
	add_child(script.new())
	pass
