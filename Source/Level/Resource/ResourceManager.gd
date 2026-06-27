extends Node

signal new_key(key:String, value:int)
signal key_update(key:String, change:int)

var current:Dictionary[String, int]
enum ResourceTypes{B,O,U}
const ResourceNames:Dictionary[ResourceTypes,String] = {
	ResourceManager.ResourceTypes.B: "Bananas",
	ResourceManager.ResourceTypes.O: "Spores",
	ResourceManager.ResourceTypes.U: "Souls",
}

var ResourceCadence:Dictionary[ResourceTypes,float] = {
	ResourceManager.ResourceTypes.B: 2.0,
	ResourceManager.ResourceTypes.O: 0.5,
	ResourceManager.ResourceTypes.U: 5.0,
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
