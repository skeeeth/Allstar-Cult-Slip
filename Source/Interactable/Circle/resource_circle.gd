extends Node2D
class_name ResourceCircle

@export var cadence:float = 10
var progress:float = 0
@export var type:ResourceManager.ResourceTypes
var store:int

@onready var interact_hitbox: Interactable = $"Interaction Area"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var count_text: Label = $"Count Text"

func _ready() -> void:
	interact_hitbox.interacted.connect(on_interaction)
	ResourceManager.stat_change.connect(stat_change)
	roll_resource()

func on_interaction():
	if store >= 1:
		ResourceManager.add_resource(ResourceManager.ResourceNames[type],store)
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
	type = t
	cadence = ResourceManager.ResourceCadence[t]

	progress_bar.max_value = cadence
	_set_text()

func _set_text():
	count_text.text = "%s: %s" % [ResourceManager.ResourceNames[type],store]
	
	
func stat_change():
	cadence =  ResourceManager.ResourceCadence[type]

static func get_upgrade(dict:Dictionary[String,float]):
	#man this seems really ugly but i dont know what other kind of type safety
	# i can do to decouple
	
	for key in dict:
		match key:
			"cadence_O":
				ResourceManager.change_cadence(
					ResourceManager.ResourceTypes.O,
					dict[key])
			"cadence_B":
				ResourceManager.change_cadence(
					ResourceManager.ResourceTypes.B,
					dict[key])
