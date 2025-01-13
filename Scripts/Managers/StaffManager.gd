extends Node2D

class_name StaffManager

@export var staff_interaction_points: Array[Node2D] = []
var is_occupied = false

func get_available_interaction_points():
	if not is_occupied:
		return staff_interaction_points[0] #Expand later for occupied points

func disable_interaction_point(occupied): 
	is_occupied = occupied
