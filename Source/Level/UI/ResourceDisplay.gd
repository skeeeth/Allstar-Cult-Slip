extends VBoxContainer


var labels:Dictionary[String,Label]

func _ready() -> void:
	ResourceManager.new_key.connect(on_new_key)
	ResourceManager.key_update.connect(on_update)
	ResourceManager.current.clear()
	for i in ResourceManager.ResourceTypes.values():
		ResourceManager.add_resource(ResourceManager.ResourceNames[i],0)


func on_new_key(k,_v):
	_new_label(k)

func on_update(type:String, change:int):
	var label = labels[type]
	_set_label_text(label,type)
	
	var squeeze = self.create_tween()
	var x_factor = pow(1.5, -1.5 * sign(change))
	var y_factor = pow(1.5, 1.5 * sign(change))
	squeeze.tween_property(label,"offset_transform_scale",
			Vector2(x_factor,y_factor),0.1)
	squeeze.tween_property(label,"offset_transform_scale",
			Vector2(1.0,1.0),0.1)


func _new_label(type:String):
	var new_label = Label.new()
	_set_label_text(new_label,type)
	new_label.offset_transform_enabled = true
	
	add_child(new_label)
	labels[type] = new_label
	

func _set_label_text(label:Label,type:String):
	label.text = "%s: %s" % [type, ResourceManager.current[type]]
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_b"):
		for i in ResourceManager.ResourceTypes.values():
			ResourceManager.add_resource(ResourceManager.ResourceNames[i],99)
		
