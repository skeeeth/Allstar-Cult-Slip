extends Node2D
class_name ResourceCircle

@export var cadence:float = 10
var progress:float = 0
@export var type:ResourceManager.ResourceTypes = ResourceManager.ResourceTypes.U
@export var random_spawn:bool = true
var store:int

@onready var interact_hitbox: Interactable = $"Interaction Area"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var count_text: Label = $"Count Text"
@onready var collect_sound: AudioStreamPlayer2D = $Harvest
#@onready var button_prompt: Sprite2D = $"Button Prompt"

var max_store:int = 99

func _ready() -> void:
	interact_hitbox.interacted.connect(on_interaction)
	ResourceManager.stat_change.connect(stat_change)
	
	#interact_hitbox.area_entered.connect(button_prompt.show)
	#interact_hitbox.area_entered.connect(button_prompt.hide)
	
	if random_spawn:
		roll_resource()

func on_interaction():
	if store >= 1:
		ResourceManager.add_resource(ResourceManager.ResourceNames[type],store)
		Scoring.add_score(store * ResourceManager.ResourceCadence[type] * 10,
				"%s Gathered" % ResourceManager.ResourceNames[type])
		store = 0
		progress = 0
		
		collect_sound.play()
		roll_resource()



func _process(delta: float) -> void:
	if store == max_store:
		return

	if progress >= cadence:
		progress -= cadence
		store += 1
		_set_text()
		
	var mult = 1
	#set dynamic cadence
	var _bc = ResourceManager.ResourceCadence[type] #base cadence
	match type:
		ResourceManager.ResourceTypes.B:
			mult = (1.0 / ((0.2 * store) + 1))
			#print(mult)
		ResourceManager.ResourceTypes.O:
			mult = pow(1.08,store/5.5)
			#print(mult)
		ResourceManager.ResourceTypes.U:
			mult = 1
				
	progress_bar.max_value = cadence
	
	progress += delta * mult
	progress_bar.value = progress

func roll_resource():
	var possible_rolls = ResourceManager.ResourceTypes.values()
	possible_rolls.erase(type)
	var t = possible_rolls.pick_random()
	type = t
	cadence = ResourceManager.ResourceCadence[t]
	
	#collect_sound.stream = ResourceManager.HarvestSounds[t]
	if !collect_sound.finished.is_connected(collect_sound.set_deferred):
		collect_sound.finished.connect(collect_sound.set_deferred.bind(
				"stream",ResourceManager.HarvestSounds[t]),4)
	
	progress_bar.max_value = cadence
	_set_text()

func _set_text():
	count_text.text = "%s: %s/%s" % \
		[ResourceManager.ResourceNames[type], store, max_store]
	
	
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
