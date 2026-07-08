extends Container
class_name Cost_Block

@onready var cost: Label = $VBoxContainer/Cost


func update_cost_text(data:Dictionary[ResourceManager.ResourceTypes,int]):
	#colored text here would be good but would bb code should have a
	# fundamentally different approach
	var cost_text:String = ""
	for k in data:
		cost_text += "%s: %s/%s\n" % \
			[ResourceManager.ResourceNames[k],
			ResourceManager.get_current(k),
			data[k]]
	
	cost.text = cost_text

#func check_afford() -> bool:
	#return true
