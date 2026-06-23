extends Node2D

@export var cadence:float = 10
var progress:float = 0
@export var type:String 
var store:int

@onready var interact_hitbox: Interactable = $"Interaction Area"

func _ready() -> void:
	interact_hitbox.interacted.connect(on_interaction)
	

func on_interaction():
	if store >= 1:
		ResourceManager.add_resource(type,store)
		store = 0

func _process(delta: float) -> void:
	progress += delta
	if progress >= cadence:
		progress -= cadence
		store += 1
