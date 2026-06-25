extends Node2D

@export var cadence:float = 10
var progress:float = 0
@export var type:String
var store:int

@onready var interact_hitbox: Interactable = $"Interaction Area"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var count_text: Label = $"Count Text"

func _ready() -> void:
	interact_hitbox.interacted.connect(on_interaction)
	roll_resource()

func on_interaction():
	if store >= 1:
		ResourceManager.add_resource(type,store)
		store = 0
		progress = 0
		roll_resource()

func _process(delta: float) -> void:
	progress += delta
	if progress >= cadence:
		progress -= cadence
		store += 1
		_set_text()
	
	progress_bar.value = progress

func roll_resource():
	var t = ResourceManager.ResourceTypes.values().pick_random()
	type = ResourceManager.ResourceNames[t]
	cadence = ResourceManager.ResourceCadence[t]

	progress_bar.max_value = cadence
	_set_text()

func _set_text():
	count_text.text = "%s: %s" % [type,store]
