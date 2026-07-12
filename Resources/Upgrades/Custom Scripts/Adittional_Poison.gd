extends Node

func _ready() -> void:
	TriggerServer.poison_applied.connect(on_poison_applied)
	
	
func on_poison_applied(_amount:int, to_who:Unit):
	#Very intentional hard set of poison to avoid causing a poison applied trigger
	to_who.poison += 1
