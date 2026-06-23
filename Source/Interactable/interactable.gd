extends Area2D
class_name Interactable

signal interacted

var player_inside:bool = false

#area assumed to only ever be player based on masks
func _on_area_entered(area: Area2D) -> void:
	assert(area.has_meta("player_hitbox"))
	player_inside = true
	
func _on_area_exited(area: Area2D) -> void:
	assert(area.has_meta("player_hitbox"))
	player_inside = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if player_inside:
			interacted.emit()
			#print("Interacted!")
