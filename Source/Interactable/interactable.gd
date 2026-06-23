extends Area2D
class_name Interactable

signal interacted

var player_inside:bool = false


func _on_area_entered(area: Area2D) -> void:
	player_inside = true
	

func _on_area_exited(area: Area2D) -> void:
	player_inside = false


func _input(event: InputEvent) -> void:
	if event.is_action("Interact"):
		if player_inside:
			interacted.emit()
			print("Interacted!")
