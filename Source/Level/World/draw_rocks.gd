extends Node2D

func _ready() -> void:
	for obs in get_children():
		if obs is NavigationObstacle2D:
			var new_polygon = Polygon2D.new()
			new_polygon.polygon = obs.vertices
			obs.add_child(new_polygon)
