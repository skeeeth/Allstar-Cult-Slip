extends Node

signal score_changed

var breakdown:Dictionary[String,float]

func save_data():
	pass

func add_score(amount:float, category:String):
	if breakdown.has(category):
		breakdown[category] += amount
	else:
		breakdown[category] = amount

func get_total_score() -> float:
	var total:float = 0
	for k in breakdown:
		total += breakdown[k]
	return total
