extends Resource
class_name ProjectileData


@export var sprite:Texture2D
@export var spash_size:float = -1.0 #for single target

@export var speed:float
var speed_mod:float = 0
@export var size = 64
var size_mod:float = 0


enum activation{END_EXPLODE, TRAVEL}
@export var activation_type:activation
var type_mod:int = 0

@export var track:bool = false

func _init() -> void:
	Scoring.game_reseting.connect(_reset_state)

func _reset_state() -> void:
	size_mod = 0
	type_mod = 0
	speed_mod = 0

func add_stats(stats:Dictionary):
	var try_add = func add_stat(key:String)-> float:
		if stats.has(key):
			return stats[key]
		else:
			return 0
			
	speed_mod += try_add.call("Speed")
	size_mod += try_add.call("Size")
	var result = ResourceSaver.save(self,resource_path)
	for t in TowerSite.tower_pool:
		if t.projectile == self:
			t.get_upgrade(stats)
	print(result)
