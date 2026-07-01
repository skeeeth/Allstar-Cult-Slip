extends Resource
class_name Upgrade


@export var name:String = "Upgrade Name"
@export var description:String = "Upgrade Description"
@export var cost:Dictionary[ResourceManager.ResourceTypes,int]


@export var unlocks:Array[Upgrade] #circular ref danger?

enum effects{BLUEPRINT, TOWER_BUFF, RESOURCE_BUFF}
@export var type:effects

@export var tower_data:TowerData

@export var stat_increases:Dictionary[String, float]
