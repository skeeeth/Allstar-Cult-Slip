extends Container
class_name Cost_Block

@onready var cost: Label = $VBoxContainer/Cost

var data_displayed:Dictionary[ResourceManager.ResourceTypes,int]

func _ready() -> void:
	ResourceManager.key_update.connect(propegate_update)

func update_cost_text(data:Dictionary[ResourceManager.ResourceTypes,int]):
	#colored text here would be good but would bb code should have a
	# fundamentally different approach
	data_displayed = data
	var cost_text:String = ""
	for k in data_displayed:
		cost_text += "%s: %s/%s\n" % \
			[ResourceManager.ResourceNames[k],
			ResourceManager.get_current(k),
			data[k]]
	
	cost.text = cost_text


#jank as fuck but whatever man
func propegate_update(_r_name:String,_amount:int):
	update_cost_text(data_displayed)

#func check_afford() -> bool:
	#return true
