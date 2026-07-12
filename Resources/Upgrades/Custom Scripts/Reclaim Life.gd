extends Node

func _ready() -> void:
	TriggerServer.poison_death.connect(gain_life)


func gain_life(_unit):
	ResourceManager.add_resource(ResourceManager.ResourceNames[ResourceManager.ResourceTypes.B],1)
	ResourceManager.add_resource(ResourceManager.ResourceNames[ResourceManager.ResourceTypes.O],1)
