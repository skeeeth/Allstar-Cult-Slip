extends Node2D

func _ready() -> void:
	for obs in get_children():
		if obs is NavigationObstacle2D:
			var new_polygon = Polygon2D.new()
			#new_polygon.polygon = obs.vertices
			var points:Array[Vector2]
			for v in obs.vertices:
				points.append(v*0.75)
			new_polygon.polygon = points
			obs.add_child(new_polygon)
