extends Resource
class_name TowerData

@export var tower_name:String
@export var sprite:Texture2D

@export var cost:Dictionary[ResourceManager.ResourceTypes,int]

enum trigger_conditions{AREA_TIME, UNIT_TIME, ENTRY, EXIT}
@export var trigger_condition:trigger_conditions

enum effect_types{DAMAGE, SLOW, SLIP}
@export var effects:Dictionary[effect_types,float] = {effect_types.DAMAGE:0}

@export var trigger_time = 1.0
@export var effect_strength:float = 10

@export var area_size:float

@export var upgrade:TowerData
