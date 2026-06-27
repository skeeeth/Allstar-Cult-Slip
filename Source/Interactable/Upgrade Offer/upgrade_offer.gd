extends Node2D
@export var interactable: Interactable

@export var offer:Upgrade

func on_interact():
	apply_upgrade()

func apply_upgrade():
	TowerSite.add_pool(offer.tower_data)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_one"):
		apply_upgrade()
