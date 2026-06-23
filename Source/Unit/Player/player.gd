extends Node2D
class_name Player

@export var movespeed:float


func _process(delta: float) -> void:
	Input.get_axis("up","down")
