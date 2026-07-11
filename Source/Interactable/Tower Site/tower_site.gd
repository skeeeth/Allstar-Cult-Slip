extends Node2D
class_name TowerSite

@onready var interaction_area: Interactable = $"Interaction Area"
@onready var info_box: HBoxContainer = $"Tower Info"
#@onready var upgrade_display: HBoxContainer = $"Upgrade Display"
@onready var build_sound: AudioStreamPlayer2D = $"Build Sound"
@onready var build_puff: CPUParticles2D = $"Build Puff"

@onready var hover_sprite: Sprite2D = $HoverSprite

var blueprint:TowerData
var current_tower:Tower
@export var starting_pool:Array[TowerData]
static var tower_pool:Array[TowerData]
static var sites:Array[TowerSite]
var displays:Array[TowerDisplay]

@export var range_color:Color
@export var current_tower_range_color:Color

func _draw() -> void:
	if hover_sprite.visible:
		if blueprint:
			draw_circle(Vector2.ZERO,blueprint.area_size,range_color)
		if current_tower:
			draw_circle(Vector2.ZERO,current_tower.data.area_size,current_tower_range_color)
	
func _ready() -> void:
	interaction_area.interacted.connect(on_interact)
	interaction_area.entered.connect(on_enter)
	interaction_area.exited.connect(on_exit)
	interaction_area.negative_interaction.connect(try_destroy)
	tower_pool = starting_pool
	TowerSite.sites.append(self)
	set_displays_from_pool()

func on_interact():
	if !blueprint: return
	
	
	for type in blueprint.cost:
		var type_name = ResourceManager.ResourceNames[type]
		#print(type)
		if !ResourceManager.try_spend(type_name,blueprint.cost[type]):
			#Resource Fail
			return
	
	for type in blueprint.cost:
		var type_name = ResourceManager.ResourceNames[type]
		ResourceManager.spend(type_name,blueprint.cost[type])
	
	#if no fail, then a success
	build()
	#queue_free()

func build():
	if current_tower:
		current_tower.queue_free()
	
	build_sound.stream = blueprint.build_sound
	
	build_sound.play()
	build_puff.emitting = true
	
	var new_tower = Tower.create(load(blueprint.resource_path))
	add_child(new_tower)
	#interaction_area.monitoring = false
	current_tower = new_tower
	clear_displays()
	
	if blueprint.upgrade:
		blueprint = blueprint.upgrade
		create_display(blueprint,0)
	else:
		blueprint = null
	
func _input(event: InputEvent) -> void:
	if !info_box.visible:
		return
	
	if event.is_action_pressed("one"):
		select_blueprint(0)
	
	if event.is_action_pressed("two"):
		select_blueprint(1)
	
	if event.is_action_pressed("three"):
		select_blueprint(2)
	
	if event.is_action_pressed("four"):
		select_blueprint(3)
	
func select_blueprint(index:int):
	if index >= displays.size():
		return
	blueprint = displays[index].tower_data
	for d in displays:
		d.clear_hover()
	displays[index].set_hover()
	hover_sprite.texture = blueprint.sprite
	hover_sprite.scale = Vector2(blueprint.draw_size,blueprint.draw_size) /  blueprint.sprite.get_size()
	queue_redraw()
	
func on_enter():
	info_box.visible = true
	hover_sprite.visible = true
	queue_redraw()
	#if data.te
	
func on_exit():
	info_box.visible = false
	hover_sprite.visible = false
	queue_redraw()

func create_display(data,index):
	var new_display = TowerDisplay.create()
	displays.append(new_display)
	info_box.add_child(new_display)
	new_display.index_number.text = str(index + 1)
	new_display.dress(data)

func clear_displays():
	for d in displays:
		d.queue_free()
	displays.clear()

func set_displays_from_pool():
	var i:int = 0
	for data in tower_pool:
		create_display(data,i)
		i += 1

func try_destroy():
	if !current_tower: #fail if no current tower
		return
	
	#you could apply some kind of refund but fuck em
	
	#do destroy
	current_tower.queue_free()
	clear_displays()
	set_displays_from_pool()
	

static func add_pool(data:TowerData):
	assert(!tower_pool.has(data))
	tower_pool.append(data)
	for s in sites:
		s.create_display(data, tower_pool.size()-1)
