extends Area2D
class_name Interactable

@export var button_prompt:Sprite2D

signal interacted
signal negative_interaction
signal entered
signal exited

var player_inside:bool = false

#area assumed to only ever be player based on masks
func _on_area_entered(area: Area2D) -> void:
	assert(area.has_meta("player_hitbox"))
	player_inside = true
	entered.emit()
	button_prompt.show()
	
func _on_area_exited(area: Area2D) -> void:
	assert(area.has_meta("player_hitbox"))
	player_inside = false
	exited.emit()
	button_prompt.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if player_inside:
			interacted.emit()
			#print("Interacted!")
	if event.is_action_pressed("esc"):
		if player_inside:
			negative_interaction.emit()
