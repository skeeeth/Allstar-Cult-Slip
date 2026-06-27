extends PanelContainer
class_name TowerDisplay

@onready var attack: Label = $"VBoxContainer/HBoxContainer/stat block/Attack"
@onready var speed: Label = $"VBoxContainer/HBoxContainer/stat block/Speed"
@onready var type: Label = $"VBoxContainer/HBoxContainer/stat block/Type"
@onready var cost: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Cost

const self_scene = preload("uid://61odise0qtd")
static  func create() -> TowerDisplay:
	var new_display = self_scene.instantiate()
	return new_display

func dress(data:TowerData):
	attack.text = "Damage: %s" % data.effect_strength
	speed.text = "Speed: %s" % data.trigger_time
	var type_text = "Target" if data.trigger_condition ==\
					data.trigger_conditions.UNIT_TIME else "AOE"
	
	type.text = type_text
	
	var cost_text:String = ""
	for k in data.cost.keys():
		cost_text += "%s: %s\n" % [k, data.cost[k]]
	
	cost.text = cost_text
