extends Node

func _ready() -> void:
	TriggerServer.unit_slipped.connect(gain_soul)


func gain_soul(_unit):
	ResourceManager.add_resource(ResourceManager.ResourceNames[ResourceManager.ResourceTypes.U],1)
