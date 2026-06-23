extends Resource
class_name TowerData

@export var cost:Dictionary[String,int]

enum trigger_conditions{AREA_TIME, UNIT_TIME, ENTRY, EXIT}
@export var trigger_condition:trigger_conditions

@export var area_size:float
