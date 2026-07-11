extends Node

func _ready() -> void:
	TriggerServer.unit_slipped.connect(apply_poison)
	
	
func apply_poison(unit:Unit):
	unit.add_poison(1)
