extends Node2D
class_name UpgradeOffer

@export var interactable: Interactable
@export var info_block:UpgradeInfo

@export var interval:float

@export var offer:Upgrade

@export var starting_pool:Array[Upgrade]
static var upgrade_pool:Array[Upgrade]

func _ready() -> void:
	upgrade_pool = starting_pool
#	change_offer()
	info_block.set_info(offer)
	interactable.interacted.connect(on_interact)
	interactable.entered.connect(on_enter)
	interactable.exited.connect(on_exit)

func on_interact():
	#check costs
	
	apply_upgrade()

func on_enter():
	info_block.visible = true

func on_exit():
	info_block.visible = false

func change_offer():
	var new_blueprint:Upgrade = upgrade_pool.pick_random()
	offer = new_blueprint
	info_block.set_info(offer)


func apply_upgrade():
	#remove all instances of offer from pool
	#cannot use simple array.erase(offer) because an upgrade may have been unlocked multiple times
	upgrade_pool.filter(func(u): return u == offer)
	
	#apply costs
	for k in offer.cost:
		ResourceManager.spend(ResourceManager.ResourceNames[k],offer.cost[k])
	
	#add unlocks to pool
	for u in offer.unlocks:
		upgrade_pool.append(u)
		
#region Do the damn thing
	match  offer.type:
		Upgrade.effects.BLUEPRINT:
			TowerSite.add_pool(offer.associated_towers[0])
		Upgrade.effects.RESOURCE_BUFF:
			ResourceCircle.get_upgrade(offer.stat_increases)
		Upgrade.effects.PROJECTILE_BUFF:
			for proj in offer.associated_proj:
				proj.add_stats(offer.stat_increases)
		Upgrade.effects.TOWER_BUFF:
			for t in offer.associated_towers:
				t.get_upgrade(offer.stat_increases)
#endregion



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_one"):
		apply_upgrade()
