extends Node

signal new_key(key:String, value:int)
signal key_update(key:String, change:int)

signal stat_change

var current:Dictionary[String, int]
enum ResourceTypes{B,O,U}

var global_triggers:Array

const ResourceNames:Dictionary[ResourceTypes,String] = {
	ResourceManager.ResourceTypes.B: "Bananas",
	ResourceManager.ResourceTypes.O: "Spores",
	ResourceManager.ResourceTypes.U: "Soul Fragments"
}

var ResourceCadence:Dictionary[ResourceTypes,float] = {
	ResourceManager.ResourceTypes.B: 0.5,
	ResourceManager.ResourceTypes.O: 1.3,
	ResourceManager.ResourceTypes.U: 2.0,
}


func add_resource(type:String, amount:int):
	if current.has(type):
		current[type] += amount
		key_update.emit(type,amount)
	else:
		current[type] = amount
		new_key.emit(type,amount)

func try_spend(type:String, amount:int) -> bool:
	if current.has(type):
		return current[type] >= amount
	else:
		return false


func spend(type:String, amount:int):
	#only call if try_spend confirms the existance and amount of type
	current[type] -= amount
	key_update.emit(type,-amount)


func get_current(key:ResourceManager.ResourceTypes):
	return current[ResourceManager.ResourceNames[key]]


func change_cadence(type:ResourceManager.ResourceTypes,amount:float):
	ResourceCadence[type] += amount
	
	stat_change.emit()

func reset():
	pass
