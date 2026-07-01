extends Node


var breakdown:Dictionary[String,float]

func save_data():
	pass

func add_score(amount:float, category:String):
	breakdown[category] += amount
	
