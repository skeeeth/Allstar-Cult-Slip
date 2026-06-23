extends Node2D

@onready var interaction_area: Interactable = $"Interaction Area"

var blueprint:TowerData 
@export var tower_pool:Array[TowerData]

func _ready() -> void:
	interaction_area.interacted.connect(on_interact)

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
		blueprint = tower_pool[0]
