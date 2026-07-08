extends Resource
class_name Upgrade


@export var name:String = "Upgrade Name"
@export var description:String = "Upgrade Description"
@export var cost:Dictionary[ResourceManager.ResourceTypes,int]


@export var unlocks:Array[Upgrade] #circular ref danger?

enum effects{BLUEPRINT, TOWER_BUFF, RESOURCE_BUFF, PROJECTILE_BUFF, CUSTOM_TRIGGER}
@export var type:effects

@export var associated_towers:Array[TowerData]
@export var associated_proj:Array[ProjectileData]
@export var trigger_script:Script

@export var stat_increases:Dictionary[String, float]
