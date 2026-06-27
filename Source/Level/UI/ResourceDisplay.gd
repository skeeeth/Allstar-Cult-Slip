extends VBoxContainer


var labels:Dictionary[String,Label]

func _ready() -> void:
	ResourceManager.new_key.connect(on_new_key)
	ResourceManager.key_update.connect(on_update)

	for i in ResourceManager.ResourceTypes.values():
		ResourceManager.add_resource(ResourceManager.ResourceNames[i],0)

func on_new_key(k,_v):
	_new_label(k)

func on_update(type:String, _change:int):
	_set_label_text(labels[type],type)

func _new_label(type:String):
	var new_label = Label.new()
	_set_label_text(new_label,type)
	add_child(new_label)
	labels[type] = new_label

func _set_label_text(label:Label,type:String):
	label.text = "%s: %s" % [type, ResourceManager.current[type]]
