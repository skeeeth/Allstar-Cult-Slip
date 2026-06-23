extends Node

signal new_key(key:String, value:int)
signal key_update(key:String, change:int)

var current:Dictionary[String, int]


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
