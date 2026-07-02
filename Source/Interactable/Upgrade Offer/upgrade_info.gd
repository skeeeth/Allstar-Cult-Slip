extends PanelContainer
class_name UpgradeInfo

@export var cost_block:Cost_Block
@export var title_line:Label
@export var description:Label

func set_info(data:Upgrade):
	cost_block.update_cost_text(data.cost)
	title_line.text = data.name
	description.text = data.description


func appear():
	visible = true
	
func disappear():
	visible = false
