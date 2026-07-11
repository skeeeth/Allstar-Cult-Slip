extends Node2D


@export var panel_sequence:Array[PanelContainer]

func _ready() -> void:
	for i in ResourceManager.ResourceTypes.values():
		ResourceManager.add_resource(ResourceManager.ResourceNames[i],0)


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("uid://dia8knv63kqum")
	pass # Replace with function body.


func _on_help_pressed() -> void:
	pass # Replace with function body.
