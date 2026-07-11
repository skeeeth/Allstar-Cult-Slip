extends PanelContainer
class_name TowerDisplay

@onready var tower_name: Label = $VBoxContainer/Name

@onready var attack: Label = $"VBoxContainer/HBoxContainer/stat block/Attack"
@onready var speed: Label = $"VBoxContainer/HBoxContainer/stat block/Speed"
@onready var type: Label = $"VBoxContainer/HBoxContainer/stat block/Type"
@export var cost: Cost_Block
@onready var icon: TextureRect = $VBoxContainer/HBoxContainer/Icon

@onready var index_number: Label = $IndexNumber
var tower_data:TowerData

@export var hover_box:StyleBox
#@export var default_box:StyleBox
var unhover_box:StyleBox = get_theme_stylebox("panel","PanelContainer")
const self_scene = preload("uid://61odise0qtd")
static  func create() -> TowerDisplay:
	var new_display = self_scene.instantiate()
	return new_display

func dress(data:TowerData, with_cost:bool = true):
	
	tower_name.text = data.tower_name
	tower_data = data
	icon.texture = data.sprite
	var effect_text:String = ""
	for e in data.effects:
		effect_text += "%s: %s\n" % [data.effect_types.find_key(e).capitalize(),
									data.effects[e]]
	attack.text = effect_text
	
	speed.text = "Speed: %s" % data.trigger_time
	#var type_text = "Single Target" if data.trigger_condition ==\
					#data.trigger_conditions.UNIT_TIME else "AOE"
	var type_text:String = ""
	if data.trigger_condition == data.trigger_conditions.UNIT_TIME:
		if data.projectile:
			if data.projectile.activation_type == ProjectileData.activation.END_EXPLODE:
				type_text = "Splash"
		type_text = "Single Target"
	else:
		type_text = "AOE"
		
	type.text = type_text
	
	cost.update_cost_text(data.cost)

func set_hover():
	add_theme_stylebox_override("panel",hover_box)
	
func clear_hover():
	add_theme_stylebox_override("panel", unhover_box)
