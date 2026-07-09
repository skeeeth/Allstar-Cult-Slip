extends HBoxContainer
class_name BreakdownEntry

const self_scene = preload("uid://o50an7jrm6w7")
@export var left:Label
@export var right:Label
static  func _create(id:String, value:float):
	var new_entry:BreakdownEntry = self_scene.instantiate()
	new_entry.left.text = id + ":"
	new_entry.right.text = "%.0f" % value

	return new_entry
