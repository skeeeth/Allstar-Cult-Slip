extends Node2D


@export var panel_sequence:Array[PanelContainer]
var panel_index:int = 0
@onready var tutorial_panel: PanelContainer = $"Tutorial Panel"



func _ready() -> void:
	for i in ResourceManager.ResourceTypes.values():
		ResourceManager.add_resource(ResourceManager.ResourceNames[i],0)


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("uid://dia8knv63kqum")
	pass # Replace with function body.


func _on_help_pressed() -> void:
	tutorial_panel.visible = !tutorial_panel.visible
	next_slide()


func _on_tutorial_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		next_slide()

func next_slide():
	panel_sequence[panel_index-1].hide()
	panel_sequence[panel_index].show()
	if panel_index + 1 == panel_sequence.size():
		panel_index = 0
	else:
		panel_index += 1
	
