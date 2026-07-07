extends Node2D
class_name Base

@export var loss_enabled:bool = false
var current_hp:float = 100
@onready var hp_label: Label = $"HP label"

func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	assert(enemy is Enemy)
	if enemy is Enemy:
		enemy.take_damage(9999)
	current_hp -= 10.0
	if current_hp <= 0 and loss_enabled:
		end_game()
		loss_enabled = false
	hp_label.text = "Base HP: %s/%s" % [current_hp, 100.0]


func end_game():
	Scoring.end_game()
	
