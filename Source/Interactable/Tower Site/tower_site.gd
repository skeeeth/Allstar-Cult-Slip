extends Node2D

@onready var interaction_area: Interactable = $"Interaction Area"
@onready var info_box: HBoxContainer = $"Tower Info"

var blueprint:TowerData 
@export var tower_pool:Array[TowerData]
var displays:Array[TowerDisplay]

func _ready() -> void:
	interaction_area.interacted.connect(on_interact)
	interaction_area.entered.connect(on_enter)
	interaction_area.exited.connect(on_exit)
	
	var i:int = 0
	for data in tower_pool:
		var new_display = TowerDisplay.create()
		displays.append(new_display)
		info_box.add_child(new_display)
		new_display.index_number.text = str(i+1)
		new_display.dress(data)
		i += 1

func on_interact():
	if !blueprint: return
	
	for type in blueprint.cost:
		#print(type)
		if !ResourceManager.try_spend(type,blueprint.cost[type]):
			#Resource Fail
			return
	
	for type in blueprint.cost:
		ResourceManager.spend(type,blueprint.cost[type])
	
	#if no fail, then a success
	var new_tower = Tower.create(blueprint)
	add_child(new_tower)
	interaction_area.monitoring = false
	#queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("one"):
		select_blueprint(0)
	
	if event.is_action_pressed("two"):
		select_blueprint(1)
		
func select_blueprint(index:int):
	blueprint = tower_pool[index]
	for d in displays:
		d.clear_hover()
	displays[index].set_hover()
	
func on_enter():
	info_box.visible = true
	#if data.te
	
func on_exit():
	info_box.visible = false
	
