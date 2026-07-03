extends Resource
class_name ProjectileData


@export var sprite:Texture2D
@export var spash_size:float = -1.0 #for single target
@export var speed:float
@export var size = 64

enum activation{END_EXPLODE, TRAVEL}
@export var activation_type:activation

@export var track:bool = false
