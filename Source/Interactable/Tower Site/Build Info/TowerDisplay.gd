extends PanelContainer
class_name TowerDisplay

@onready var tower_name: Label = $VBoxContainer/Name

@onready var attack: Label = $"VBoxContainer/HBoxContainer/stat block/Attack"
@onready var speed: Label = $"VBoxContainer/HBoxContainer/stat block/Speed"
@onready var type: Label = $"VBoxContainer/HBoxContainer/stat block/Type"
@onready var cost: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Cost
@onready var index_number: Label = $IndexNumber


@export var hover_box:StyleBox
#@export var default_box:StyleBox
var unhover_box:StyleBox = get_theme_stylebox("panel","PanelContainer")
const self_scene = preload("uid://61odise0qtd")
static  func create() -> TowerDisplay:
	var new_display = self_scene.instantiate()
	return new_display

func dress(data:TowerData, with_cost:bool = true):
	
	tower_name.text = data.tower_name
	attack.text = "Damage: %s" % data.effect_strength
	speed.text = "Speed: %s" % data.trigger_time
	var type_text = "Target" if data.trigger_condition ==\
					data.trigger_conditions.UNIT_TIME else "AOE"
	type.text = type_text
	
	update_cost_text(data)
	

func update_cost_text(data:TowerData):
	#colored text here would be good but would bb code should have a
	# fundamentally different approach
	var cost_text:String = ""
	for k in data.cost.keys():
		cost_text += "%s: %s/%s\n" % [k, ResourceManager.current[k], data.cost[k]]
	
	cost.text = cost_text
	
func set_hover():
	add_theme_stylebox_override("panel",hover_box)
	
func clear_hover():
	add_theme_stylebox_override("panel", unhover_box)
