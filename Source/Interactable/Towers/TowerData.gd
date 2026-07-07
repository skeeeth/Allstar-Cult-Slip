extends Resource
class_name TowerData

@export var tower_name:String
@export var sprite:Texture2D
@export var build_sound:AudioStream

@export var cost:Dictionary[ResourceManager.ResourceTypes,int]

enum trigger_conditions{AREA_TIME, UNIT_TIME, ENTRY, EXIT}
@export var trigger_condition:trigger_conditions

enum effect_types{DAMAGE, SLOW, SLIP}
@export var effects:Dictionary[effect_types,float] = {effect_types.DAMAGE:0}
var effect_mod:Dictionary[effect_types,float]

@export var trigger_time = 1.0
var speed_mod:float = 0
#@export var effect_strength:float = 10

@export var area_size:float
var range_mod = 0

@export var projectile:ProjectileData

@export var upgrade:TowerData


func _init() -> void:
	Scoring.game_reseting.connect(_reset_state)

func _reset_state() -> void:
	effect_mod.clear()
	speed_mod = 0
	range_mod = 0


func get_upgrade(stats:Dictionary):
	var try_add = func add_stat(key:String)-> float:
		if stats.has(key):
			return stats[key]
		else:
			return 0
		
	var add_effect = func add_e(effect:effect_types,amount:float):
		if effect_mod.has(effect):
			effect_mod[effect] += amount
		else:
			effect_mod[effect] = amount
	
	add_effect.call(effect_types.DAMAGE,try_add.call("Damage"))
	add_effect.call(effect_types.DAMAGE,try_add.call("Slip"))
	
	range_mod = try_add.call("Range")
	speed_mod = try_add.call("Speed")
	
	
	ResourceSaver.save(self,resource_path)
