extends Node2D

class_name StaffManager

@export var staff_interaction_points: Array[Node2D] = []

func get_available_interaction_points():
	return staff_interaction_points #Expand later for occupied points
