extends Node2D
class_name TowerSite

@onready var interaction_area: Interactable = $"Interaction Area"
@onready var info_box: HBoxContainer = $"Tower Info"
#@onready var upgrade_display: HBoxContainer = $"Upgrade Display"

@onready var hover_sprite: Sprite2D = $HoverSprite

var blueprint:TowerData
var current_tower:Tower
@export var starting_pool:Array[TowerData]
static var tower_pool:Array[TowerData]
static var sites:Array[TowerSite]
var displays:Array[TowerDisplay]

@export var range_color:Color

func _draw() -> void:
	if blueprint and hover_sprite.visible:
		draw_circle(Vector2.ZERO,blueprint.area_size,range_color)
	
func _ready() -> void:
	interaction_area.interacted.connect(on_interact)
	interaction_area.entered.connect(on_enter)
	interaction_area.exited.connect(on_exit)
	tower_pool = starting_pool
	TowerSite.sites.append(self)
	var i:int = 0
	for data in tower_pool:
		create_display(data,i)
		i += 1

func on_interact():
	if !blueprint: return
	
	for type in blueprint.cost:
		#print(type)
		if !ResourceManager.try_spend(type,blueprint.cost[type]):
			#Resource Fail
			return
	
	for type in blueprint.cost:
		ResourceManager.spend(type,blueprint.cost[type])
	
	#if no fail, then a success
	build()
	#queue_free()

func build():
	if current_tower:
		current_tower.queue_free()
	
	var new_tower = Tower.create(blueprint)
	add_child(new_tower)
	#interaction_area.monitoring = false
	current_tower = new_tower
	if blueprint.upgrade:
		blueprint = blueprint.upgrade

	
func _input(event: InputEvent) -> void:
	if !info_box.visible:
		return
	
	if event.is_action_pressed("one"):
		select_blueprint(0)
	
	if event.is_action_pressed("two"):
		select_blueprint(1)
	
	if event.is_action_pressed("three"):
		select_blueprint(2)
	
func select_blueprint(index:int):
	if index >= tower_pool.size():
		return
	blueprint = tower_pool[index]
	for d in displays:
		d.clear_hover()
	displays[index].set_hover()
	hover_sprite.texture = blueprint.sprite
	
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

static func add_pool(data:TowerData):
	assert(!tower_pool.has(data))
	tower_pool.append(data)
	for s in sites:
		s.create_display(data, tower_pool.size()-1)
